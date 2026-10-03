"""Build the tutorial office asset in Blender; run with blender --background --python.

Source: assets/blender/rifkin_office.blend
Export: godot/assets/office/rifkin_office.glb
This asset contains terminal markers, not gameplay scripts.
"""

import argparse
from array import array
import math
from pathlib import Path
import random
import sys

import bpy
from mathutils import Vector

ROOT = Path(__file__).resolve().parents[1]
TEXTURES = ROOT / "assets/office/textures"
PREVIEWS = ROOT / "assets/office/previews"
SOURCE = ROOT / "assets/blender/rifkin_office.blend"
EXPORT = ROOT / "godot/assets/office/rifkin_office.glb"
for directory in (TEXTURES, PREVIEWS, SOURCE.parent, EXPORT.parent):
    directory.mkdir(parents=True, exist_ok=True)

args = argparse.ArgumentParser()
args.add_argument("--samples", type=int, default=48)
args.add_argument("--width", type=int, default=1600)
options = args.parse_args(sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else [])

bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.context.preferences.filepaths.save_version = 0
scene = bpy.context.scene
scene.unit_settings.system = "METRIC"
scene.unit_settings.scale_length = 1.0
scene["company"] = "Rifkin Software"
scene["unseen_supervisor"] = "Joel"
scene["stage"] = "Night Shift Checkout / tutorial office"
scene["asset_scope"] = "Player cubicle and surrounding static office; no gameplay wiring"

collections = {}
for name in ("00_Room", "01_PlayerCubicle", "02_EmptyWorkstations", "03_OfficeDetails", "04_Lighting", "05_Cameras", "06_GodotLights"):
    collection = bpy.data.collections.new(name)
    scene.collection.children.link(collection)
    collections[name] = collection
current_collection = collections["00_Room"]


def place(obj, name, parent=None):
    obj.name = name
    for collection in list(obj.users_collection):
        collection.objects.unlink(obj)
    current_collection.objects.link(obj)
    if parent:
        obj.parent = parent
    return obj


def material(name, color, roughness=0.7, metallic=0.0, emission=0.0):
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    mat.diffuse_color = (*color, 1.0)
    shader = mat.node_tree.nodes.get("Principled BSDF")
    shader.inputs["Base Color"].default_value = (*color, 1.0)
    shader.inputs["Roughness"].default_value = roughness
    shader.inputs["Metallic"].default_value = metallic
    if emission:
        shader.inputs["Emission Color"].default_value = (*color, 1.0)
        shader.inputs["Emission Strength"].default_value = emission
    return mat


def texture_material(name, filename, roughness=0.7, emission=0.0):
    mat = material(name, (0.8, 0.8, 0.8), roughness)
    texture = mat.node_tree.nodes.new("ShaderNodeTexImage")
    texture.image = bpy.data.images.load(str(TEXTURES / filename), check_existing=True)
    shader = mat.node_tree.nodes.get("Principled BSDF")
    mat.node_tree.links.new(texture.outputs["Color"], shader.inputs["Base Color"])
    if emission:
        mat.node_tree.links.new(texture.outputs["Color"], shader.inputs["Emission Color"])
        shader.inputs["Emission Strength"].default_value = emission
    return mat


def tile_image(name, color, kind):
    rng = random.Random(41)
    size = 256
    pixels = array("f")
    for y in range(size):
        for x in range(size):
            noise = rng.uniform(-0.07, 0.07)
            if kind == "fabric":
                noise = noise * 0.24 + (0.014 if x % 3 == 0 else -0.005) + (0.012 if y % 3 == 0 else -0.004)
            elif kind == "carpet":
                noise += rng.choice((-0.025, 0.0, 0.018, 0.035))
            elif kind == "ceiling":
                noise = noise * 0.25 - (0.11 if rng.random() < 0.025 else 0)
            elif kind == "laminate":
                noise = 0.023 * math.sin(x * 0.09 + math.sin(y * 0.04)) + noise * 0.2
            pixels.extend(max(0.0, min(1.0, channel + noise)) for channel in color)
            pixels.append(1.0)
    image = bpy.data.images.new(name, width=size, height=size)
    image.pixels.foreach_set(pixels)
    image.filepath_raw = str(TEXTURES / f"{name}.png")
    image.file_format = "PNG"
    image.save()
    return texture_material(name, f"{name}.png")


carpet = tile_image("office_carpet", (0.24, 0.255, 0.225), "carpet")
fabric = tile_image("partition_fabric", (0.48, 0.46, 0.38), "fabric")
ceiling = tile_image("ceiling_tile", (0.72, 0.715, 0.66), "ceiling")
laminate = tile_image("desk_laminate", (0.49, 0.415, 0.29), "laminate")
paint = material("Aged warm wall paint", (0.58, 0.57, 0.49))
trim = material("Dull taupe metal", (0.31, 0.30, 0.25), 0.52, 0.2)
black = material("Charcoal molded plastic", (0.027, 0.033, 0.032), 0.46)
keyboard_mat = material("Yellowed keyboard plastic", (0.49, 0.46, 0.36), 0.6)
key_mat = material("Worn keycaps", (0.65, 0.62, 0.50), 0.67)
steel = material("Brushed dull steel", (0.28, 0.30, 0.29), 0.35, 0.75)
chair_fabric = material("Charcoal woven seat", (0.07, 0.085, 0.075), 0.94)
paper = material("Warm paper edge", (0.78, 0.73, 0.60), 0.9)
coffee = material("Cold coffee", (0.027, 0.014, 0.006), 0.25)
ceramic = material("Stained office mug", (0.60, 0.585, 0.50), 0.32)
off_screen = material("Unpowered monitor glass", (0.009, 0.018, 0.019), 0.18, 0.12)
warm_light = material("Warm fluorescent diffuser", (0.86, 0.85, 0.66), 0.7, emission=3.5)
cold_light = material("Cold fluorescent diffuser", (0.71, 0.83, 0.80), 0.7, emission=4.2)
dead_light = material("Failed fluorescent diffuser", (0.20, 0.22, 0.18), 0.7)
green_led = material("Player power indicator", (0.14, 0.68, 0.31), emission=2.0)


def box(name, location, dimensions, mat, bevel=0.0, parent=None):
    bpy.ops.mesh.primitive_cube_add(size=1, location=location)
    obj = place(bpy.context.object, name, parent)
    obj.dimensions = dimensions
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    tile_size = {fabric: 0.25, carpet: 0.6, laminate: 1.2, ceiling: 1.0}.get(mat)
    if tile_size:
        for face in obj.data.polygons:
            normal = face.normal
            axes = (0, 1) if abs(normal.z) > 0.5 else ((0, 2) if abs(normal.y) > 0.5 else (1, 2))
            for loop_index in face.loop_indices:
                vertex = obj.data.vertices[obj.data.loops[loop_index].vertex_index].co
                obj.data.uv_layers.active.data[loop_index].uv = (vertex[axes[0]] / tile_size, vertex[axes[1]] / tile_size)
    if bevel:
        modifier = obj.modifiers.new("Soft manufactured edges", "BEVEL")
        modifier.width = bevel
        modifier.segments = 2
    return obj


def cylinder(name, location, radius, depth, mat, vertices=20, parent=None):
    bpy.ops.mesh.primitive_cylinder_add(vertices=vertices, radius=radius, depth=depth, location=location)
    obj = place(bpy.context.object, name, parent)
    obj.data.materials.append(mat)
    bevel = obj.modifiers.new("Edge wear", "BEVEL")
    bevel.width = min(radius * 0.10, 0.008)
    bevel.segments = 2
    return obj


def rod(name, start, end, radius, mat, parent=None):
    start, end = Vector(start), Vector(end)
    obj = cylinder(name, (start + end) / 2, radius, (end - start).length, mat, 12, parent)
    obj.rotation_euler = (end - start).to_track_quat("Z", "Y").to_euler()
    return obj


def surface(name, location, width, height, mat, rotation=(0, 0, 0), repeats=(1, 1), parent=None):
    mesh = bpy.data.meshes.new(name)
    mesh.from_pydata([(-width / 2, -height / 2, 0), (width / 2, -height / 2, 0), (width / 2, height / 2, 0), (-width / 2, height / 2, 0)], [], [(0, 1, 2, 3)])
    mesh.uv_layers.new(name="UVMap")
    for loop, uv in zip(mesh.uv_layers.active.data, ((0, 0), (repeats[0], 0), repeats, (0, repeats[1]))):
        loop.uv = uv
    obj = bpy.data.objects.new(name, mesh)
    current_collection.objects.link(obj)
    obj.location = location
    obj.rotation_euler = rotation
    obj.data.materials.append(mat)
    if parent:
        obj.parent = parent
    return obj


def label(name, body, location, size, mat, rotation=(math.pi / 2, 0, 0), parent=None):
    curve = bpy.data.curves.new(name, type="FONT")
    curve.body = body
    curve.size = size
    curve.align_x = "CENTER"
    curve.align_y = "CENTER"
    curve.extrude = 0.0005
    curve.font = bpy.data.fonts.load("C:/Windows/Fonts/consola.ttf", check_existing=True)
    obj = bpy.data.objects.new(name, curve)
    current_collection.objects.link(obj)
    obj.location = location
    obj.rotation_euler = rotation
    obj.data.materials.append(mat)
    if parent:
        obj.parent = parent
    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)
    bpy.ops.object.convert(target="MESH")
    obj.select_set(False)
    return bpy.context.object


def marker(name, location, role, interactive=False):
    obj = bpy.data.objects.new(name, None)
    current_collection.objects.link(obj)
    obj.location = location
    obj["role"] = role
    obj["interactable"] = interactive
    return obj


def area_light(name, location, target, energy, color, size, size_y=None):
    data = bpy.data.lights.new(name, "AREA")
    data.energy = energy
    data.color = color
    data.shape = "RECTANGLE" if size_y else "DISK"
    data.size = size
    if size_y:
        data.size_y = size_y
    obj = bpy.data.objects.new(name, data)
    collections["04_Lighting"].objects.link(obj)
    obj.location = location
    obj.rotation_euler = (Vector(target) - obj.location).to_track_quat("-Z", "Y").to_euler()
    # A hidden spotlight counterpart travels through glTF; area lamps remain for Blender rendering.
    export_data = bpy.data.lights.new(name + " / Godot", "SPOT")
    export_data.energy = energy
    export_data.color = color
    export_data.spot_size = math.radians(120)
    export_data.spot_blend = 0.4
    export_data.use_custom_distance = True
    export_data.cutoff_distance = 8
    export_obj = bpy.data.objects.new(name + " / Godot", export_data)
    collections["06_GodotLights"].objects.link(export_obj)
    export_obj.location = location
    export_obj.rotation_euler = obj.rotation_euler
    export_obj.hide_render = True
    export_obj["role"] = "godot_light_counterpart"
    return obj


# Enclosure and suspended ceiling: realistic dimensions, deliberately repetitive.
box("Floor", (0, 0.5, -0.09), (14, 13, 0.18), carpet)
surface("Carpet surface", (0, 0.5, 0.005), 14, 13, carpet, repeats=(28, 26))
box("Wall west", (-7.05, 0.5, 1.65), (0.14, 13, 3.3), paint)
box("Wall east", (7.05, 0.5, 1.65), (0.14, 13, 3.3), paint)
box("Wall north", (0, 7.05, 1.65), (14.2, 0.14, 3.3), paint)
box("Wall south", (0, -6.05, 1.65), (14.2, 0.14, 3.3), paint)
for x in (-6.98, 6.98):
    box("Perimeter skirting", (x, 0.5, 0.065), (0.028, 13, 0.13), trim)
for y in (-5.98, 6.98):
    box("Perimeter skirting", (0, y, 0.065), (14, 0.028, 0.13), trim)
box("Ceiling backing", (0, 0.5, 3.34), (14, 13, 0.10), ceiling)
for x in range(-7, 7):
    for y in range(-6, 7):
        surface(f"Acoustic ceiling {x}_{y}", (x + 0.5, y + 0.5, 3.285), 0.985, 0.985, ceiling, rotation=(math.pi, 0, 0))
for x in range(-7, 8):
    box("Ceiling grid", (x, 0.5, 3.267), (0.017, 13, 0.020), trim)
for y in range(-6, 8):
    box("Ceiling grid", (0, y, 3.267), (14, 0.017, 0.020), trim)

for i, (x, y, power, cold) in enumerate(((-2.6, -2.0, 115, False), (1.0, -2.0, 75, True), (-2.6, 1.4, 65, True), (1.0, 1.4, 0, True), (-2.6, 4.8, 48, False), (1.0, 4.8, 90, True), (5.0, 3.6, 35, True))):
    box(f"Fluorescent housing {i}", (x, y, 3.24), (1.30, 0.42, 0.065), trim, 0.007)
    box(f"Fluorescent diffuser {i}", (x, y, 3.202), (1.23, 0.35, 0.01), (cold_light if cold else warm_light) if power else dead_light)
    for offset in (-0.115, 0, 0.115):
        box("Diffuser seam", (x, y + offset, 3.194), (1.22, 0.006, 0.005), trim)
    if power:
        area_light(f"Ceiling illumination {i}", (x, y, 3.17), (x, y, 0), power, (0.76, 0.88, 0.84) if cold else (1.0, 0.88, 0.65), 1.18, 0.32)


def chair(x, y, name, rotation=0):
    parent = marker(name, (0, 0, 0), "static_chair")
    cylinder(name + " column", (x, y, 0.30), 0.035, 0.48, steel, parent=parent)
    box(name + " seat", (x, y, 0.47), (0.50, 0.49, 0.105), chair_fabric, 0.055, parent)
    box(name + " back", (x, y - 0.235, 0.83), (0.46, 0.11, 0.55), chair_fabric, 0.06, parent)
    for side in (-1, 1):
        rod(name + " back support", (x + side * 0.16, y - 0.21, 0.44), (x + side * 0.16, y - 0.21, 0.90), 0.016, black, parent)
        rod(name + " arm post", (x + side * 0.29, y + 0.02, 0.44), (x + side * 0.29, y + 0.02, 0.66), 0.018, black, parent)
        box(name + " armrest", (x + side * 0.29, y + 0.035, 0.68), (0.06, 0.31, 0.045), black, 0.016, parent)
    for angle in range(5):
        theta = angle * math.tau / 5
        end = (x + math.cos(theta) * 0.31, y + math.sin(theta) * 0.31, 0.075)
        rod(name + " caster spoke", (x, y, 0.13), end, 0.018, black, parent)
        wheel = cylinder(name + " caster", (end[0], end[1], 0.047), 0.045, 0.034, black, 12, parent)
        wheel.rotation_euler[1] = math.pi / 2


def cubicle(x, y, number, player=False):
    global current_collection
    current_collection = collections["01_PlayerCubicle" if player else "02_EmptyWorkstations"]
    prefix = "Player" if player else f"Vacant{number:02d}"
    for px, py, dims in ((x, y + 1.0, (3.1, 0.085, 1.63)), (x - 1.55, y - 0.20, (0.085, 2.45, 1.63)), (x + 1.55, y - 0.20, (0.085, 2.45, 1.63))):
        box(prefix + " fabric partition", (px, py, 0.835), dims, fabric, 0.006)
        box(prefix + " partition top rail", (px, py, 1.662), (dims[0] + 0.015, dims[1] + 0.015, 0.035), trim, 0.006)
        box(prefix + " partition bottom rail", (px, py, 0.09), (dims[0], dims[1], 0.14), trim, 0.004)
    for dx in (-1.55, 1.55):
        for dy in (-1.425, 1.0):
            box(prefix + " partition upright", (x + dx, y + dy, 0.85), (0.075, 0.075, 1.71), trim, 0.003)
    desk_y = y + 0.48
    box(prefix + " desk top", (x, desk_y, 0.755), (2.77, 0.86, 0.046), laminate, 0.014)
    box(prefix + " desk edge", (x, desk_y - 0.426, 0.747), (2.77, 0.02, 0.048), trim, 0.006)
    box(prefix + " modesty panel", (x, desk_y + 0.24, 0.43), (2.58, 0.027, 0.42), trim, 0.003)
    for dx in (-1.15, 1.15):
        box(prefix + " desk leg", (x + dx, desk_y, 0.36), (0.055, 0.055, 0.72), steel, 0.005)
        box(prefix + " desk foot", (x + dx, desk_y, 0.055), (0.09, 0.64, 0.055), black, 0.01)
    box(prefix + " drawer pedestal", (x - 0.98, desk_y - 0.02, 0.345), (0.47, 0.59, 0.65), trim, 0.018)
    for height in (0.23, 0.51):
        box(prefix + " drawer face", (x - 0.98, desk_y - 0.327, height), (0.445, 0.018, 0.245), trim, 0.004)
        box(prefix + " drawer pull", (x - 0.98, desk_y - 0.347, height + 0.06), (0.15, 0.025, 0.017), steel, 0.004)
    terminal = marker("PlayerComputer" if player else f"BackgroundComputer{number:02d}", (0, 0, 0), "player_terminal" if player else "background_terminal", player)
    terminal["workstation"] = "04" if player else f"{number:02d}"
    box(prefix + " monitor foot", (x, desk_y + 0.04, 0.803), (0.34, 0.21, 0.035), black, 0.02, terminal)
    box(prefix + " monitor stand", (x, desk_y + 0.16, 0.94), (0.075, 0.075, 0.25), black, 0.009, terminal)
    box(prefix + " monitor housing", (x, desk_y + 0.16, 1.155), (0.73, 0.14, 0.49), black, 0.025, terminal)
    screen_material = texture_material("Player screen / online", "player_screen.png", 0.38, 0.65) if player else off_screen
    surface(prefix + " screen", (x, desk_y + 0.083, 1.168), 0.658, 0.411, screen_material, rotation=(math.pi / 2, 0, 0), parent=terminal)
    if player:
        box("Player monitor power light", (x + 0.292, desk_y + 0.082, 0.947), (0.011, 0.004, 0.005), green_led, parent=terminal)
        area_light("Player screen spill", (x, desk_y + 0.04, 1.13), (x, y - 0.65, 0.8), 7.5, (0.29, 0.60, 0.66), 0.60, 0.34)
    keyboard = box(prefix + " keyboard", (x - 0.05, desk_y - 0.255, 0.811), (0.48, 0.16, 0.035), keyboard_mat, 0.009, terminal)
    for row in range(4):
        for col in range(14):
            box(prefix + " key", (x - 0.25 + col * 0.030, desk_y - 0.30 + row * 0.032, 0.835), (0.025, 0.026, 0.013), key_mat, 0.002, terminal)
            if player and col < 10:
                legend = ("ZXCVBNM,./", "ASDFGHJKL;", "QWERTYUIOP", "1234567890")[row][col]
                label("Player key legend", legend, (x - 0.25 + col * 0.030, desk_y - 0.30 + row * 0.032, 0.842), 0.007, black, rotation=(0, 0, 0), parent=terminal)
    box(prefix + " space bar", (x - 0.05, desk_y - 0.328, 0.835), (0.17, 0.019, 0.013), key_mat, 0.003, terminal)
    box(prefix + " mouse mat", (x + 0.39, desk_y - 0.23, 0.785), (0.26, 0.23, 0.005), chair_fabric, 0.007, terminal)
    box(prefix + " mouse", (x + 0.37, desk_y - 0.23, 0.808), (0.058, 0.092, 0.042), keyboard_mat, 0.022, terminal)
    box(prefix + " computer tower", (x + 0.96, desk_y + 0.09, 0.27), (0.20, 0.44, 0.47), black, 0.012, terminal)
    for z in (0.40, 0.43):
        box(prefix + " drive bay", (x + 0.96, desk_y - 0.135, z), (0.16, 0.007, 0.025), trim, parent=terminal)
    label(prefix + " desk number", "04" if player else f"{number:02d}", (x + 1.20, y + 0.95, 1.5), 0.062, trim)
    if player:
        chair(x + 0.53, y - 0.8, "Player chair")
        note_mat = texture_material("Joel's paper note", "joel_note.png", 0.9)
        box("Joel note paper", (x - 0.88, y + 0.950, 1.21), (0.35, 0.003, 0.28), paper)
        note = surface("Joel note / readable", (x - 0.88, y + 0.947, 1.21), 0.35, 0.28, note_mat, rotation=(math.pi / 2, 0, 0))
        box("Joel note pin", (x - 0.88, y + 0.940, 1.345), (0.015, 0.009, 0.007), black, 0.002)
        note["author"] = "Joel"
        note["role"] = "supervisor_note"
        sheet_mat = texture_material("Incident 4812 sheet", "incident_sheet.png", 0.9)
        box("Evidence papers", (x - 0.84, desk_y - 0.19, 0.784), (0.24, 0.31, 0.006), paper)
        surface("Incident printout / readable", (x - 0.84, desk_y - 0.19, 0.788), 0.24, 0.31, sheet_mat, rotation=(0, 0, 0.08))
        cylinder("Mug body", (x + 0.79, desk_y - 0.16, 0.837), 0.048, 0.11, ceramic, 32)
        cylinder("Mug dark interior", (x + 0.79, desk_y - 0.16, 0.894), 0.040, 0.002, coffee, 32)
        bpy.ops.mesh.primitive_torus_add(major_radius=0.032, minor_radius=0.008, major_segments=24, minor_segments=10, location=(x + 0.844, desk_y - 0.16, 0.84), rotation=(math.pi / 2, 0, 0))
        place(bpy.context.object, "Mug handle").data.materials.append(ceramic)
        box("Pen", (x - 0.59, desk_y - 0.08, 0.79), (0.008, 0.13, 0.008), black, 0.003)
        # Cable routes stay tucked against the desk rather than crossing the walking space.
        cable_points = ((x, desk_y + 0.24, 1.08), (x + 0.08, desk_y + 0.28, 0.79), (x + 0.94, desk_y + 0.28, 0.79), (x + 0.94, desk_y + 0.35, 0.51))
        for start, end in zip(cable_points, cable_points[1:]):
            rod("Player monitor cable", start, end, 0.003, black)
        marker("PlayerSpawn", (x - 0.12, y - 1.13, 1.64), "first_person_spawn")
    else:
        chair(x + 0.16, y - 0.55, prefix + " chair")
    return terminal


player = cubicle(-2.6, -2.2, 4, True)
for x, y, number in ((1.0, -2.2, 5), (-2.6, 1.15, 7), (1.0, 1.15, 8), (-2.6, 4.5, 11), (1.0, 4.5, 12)):
    cubicle(x, y, number)

current_collection = collections["03_OfficeDetails"]
# Plain institutional door: Joel's presence stays offscreen.
box("Service door frame", (5.15, 6.94, 1.13), (1.2, 0.11, 2.26), trim, 0.008)
box("Service door leaf", (5.15, 6.865, 1.1), (1.06, 0.05, 2.16), keyboard_mat, 0.006)
box("Service door lever", (5.57, 6.82, 1.03), (0.18, 0.038, 0.027), steel, 0.008)
label("Door placard", "STAFF ONLY", (5.15, 6.824, 1.7), 0.065, black)
sign_mat = texture_material("Rifkin corporate sign", "company_sign.png", 0.62)
box("Corporate sign backing", (-2.2, 6.91, 2.40), (3.2, 0.045, 1.20), black, 0.016)
surface("Rifkin Software wall sign", (-2.2, 6.881, 2.40), 3.15, 1.18, sign_mat, rotation=(math.pi / 2, 0, 0))
box("Office clock housing", (1.65, 6.91, 2.55), (0.36, 0.055, 0.36), black, 0.06)
surface("Clock face", (1.65, 6.879, 2.55), 0.30, 0.30, paper, rotation=(math.pi / 2, 0, 0))
for theta in range(12):
    angle = theta * math.tau / 12
    dot = box("Clock mark", (1.65 + math.sin(angle) * 0.124, 6.87, 2.55 + math.cos(angle) * 0.124), (0.008, 0.004, 0.018), black)
    dot.rotation_euler[1] = angle
rod("Clock minute hand / 17", (1.65, 6.86, 2.55), (1.65 + 0.105 * math.sin(17 * math.tau / 60), 6.86, 2.55 + 0.105 * math.cos(17 * math.tau / 60)), 0.004, black)
rod("Clock hour hand / 01", (1.65, 6.855, 2.55), (1.65 + 0.068 * math.sin(1.28 * math.tau / 12), 6.855, 2.55 + 0.068 * math.cos(1.28 * math.tau / 12)), 0.005, black)
for x in (4.9, 5.8):
    box("Archive cabinet", (x, 5.12, 0.65), (0.77, 0.68, 1.3), trim, 0.018)
    for z in (0.25, 0.65, 1.05):
        box("Archive cabinet drawer", (x, 4.769, z), (0.715, 0.018, 0.34), trim, 0.003)
        box("Archive cabinet handle", (x, 4.743, z + 0.085), (0.18, 0.03, 0.024), steel, 0.004)
        box("Archive label pocket", (x, 4.744, z - 0.02), (0.12, 0.006, 0.055), paper, 0.001)
box("Vent grille backing", (-6.955, 3.25, 2.80), (0.03, 1.05, 0.22), black)
for z in range(7):
    box("Vent grille slat", (-6.93, 3.25, 2.71 + z * 0.027), (0.021, 1.05, 0.012), trim)
box("Sealed interior window frame", (6.947, 0.65, 1.95), (0.055, 2.45, 1.35), trim)
box("Sealed interior window", (6.912, 0.65, 1.95), (0.035, 2.36, 1.25), off_screen)
for y in range(15):
    box("Closed blind slat", (6.885, -0.45 + y * 0.15, 1.95), (0.025, 0.10, 1.23), keyboard_mat, 0.002)
label("Floor wayfinding", "OPERATIONS   /   04", (-6.945, -3.9, 1.6), 0.075, trim, rotation=(math.pi / 2, 0, math.pi / 2))

# Two review cameras; the primary view is at standing player eye level.
current_collection = collections["05_Cameras"]
def camera(name, location, target, lens):
    data = bpy.data.cameras.new(name)
    data.lens = lens
    data.clip_start = 0.04
    data.clip_end = 60
    obj = bpy.data.objects.new(name, data)
    current_collection.objects.link(obj)
    obj.location = location
    obj.rotation_euler = (Vector(target) - obj.location).to_track_quat("-Z", "Y").to_euler()
    return obj

cubicle_camera = camera("Cubicle review", (-2.5, -3.67, 1.64), (-2.65, -1.60, 1.18), 23)
room_camera = camera("Office review", (5.7, -5.48, 2.12), (-1.6, 1.0, 1.45), 24)
scene.camera = cubicle_camera
scene.world = bpy.data.worlds.new("Night office ambient")
scene.world.use_nodes = True
scene.world.node_tree.nodes["Background"].inputs["Color"].default_value = (0.15, 0.19, 0.17, 1.0)
scene.world.node_tree.nodes["Background"].inputs["Strength"].default_value = 0.10
scene.render.engine = "CYCLES"
scene.cycles.samples = options.samples
scene.cycles.use_denoising = True
scene.cycles.max_bounces = 8
scene.cycles.device = "GPU"
cycles_preferences = bpy.context.preferences.addons["cycles"].preferences
cycles_preferences.compute_device_type = "OPTIX"
cycles_preferences.get_devices()
for device in cycles_preferences.devices:
    device.use = device.type == "OPTIX"
scene.render.resolution_x = options.width
scene.render.resolution_y = int(options.width * 0.625)
scene.render.resolution_percentage = 100
scene.render.image_settings.file_format = "PNG"
scene.view_settings.view_transform = "AgX"
scene.view_settings.look = "AgX - Medium High Contrast"
scene.view_settings.exposure = 0.5

# glTF carries image-based PBR surfaces, object extras and cameras.
# Blender area lights are kept in the source; spot counterparts carry basic Godot lighting.
bpy.ops.object.select_all(action="DESELECT")
for obj in scene.objects:
    if obj.type != "LIGHT" or obj.data.type == "SPOT":
        obj.select_set(True)
bpy.ops.export_scene.gltf(filepath=str(EXPORT), export_format="GLB", use_selection=True, export_extras=True, export_cameras=True, export_lights=True, export_apply=True)
for obj in collections["06_GodotLights"].objects:
    obj.hide_viewport = True

# Save a useful camera/material viewport without editing Blender's global preferences.
for screen in bpy.data.screens:
    for area in screen.areas:
        if area.type == "VIEW_3D":
            area.spaces.active.region_3d.view_perspective = "CAMERA"
            area.spaces.active.shading.type = "MATERIAL"
            area.spaces.active.shading.use_scene_lights = True
            area.spaces.active.shading.use_scene_world = True
            area.spaces.active.overlay.show_overlays = False
for image in bpy.data.images:
    if image.source == "FILE":
        image.pack()
bpy.ops.object.select_all(action="DESELECT")
player.select_set(True)
bpy.context.view_layer.objects.active = player
bpy.ops.wm.save_as_mainfile(filepath=str(SOURCE))
for review_camera, name in ((cubicle_camera, "cubicle"), (room_camera, "office")):
    scene.camera = review_camera
    scene.render.filepath = str(PREVIEWS / f"{name}.png")
    bpy.ops.render.render(write_still=True)
scene.camera = cubicle_camera
scene.render.filepath = str(PREVIEWS / "cubicle.png")
bpy.ops.wm.save_as_mainfile(filepath=str(SOURCE))
print(f"OFFICE_ASSET_READY: {SOURCE}\nGODOT_EXPORT: {EXPORT}")
