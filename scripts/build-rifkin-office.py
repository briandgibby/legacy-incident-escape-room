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
scene["asset_scope"] = "Office, break room, two elevator landings and exit corridor; gameplay wired in Godot"

collections = {}
for name in ("00_Room", "01_PlayerCubicle", "02_EmptyWorkstations", "03_OfficeDetails", "04_Lighting", "05_Cameras", "06_GodotLights", "07_Exterior", "08_Building"):
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
# The open window overlooks the retention equipment below the office floor.
box("Wall east south of window", (7.05, -3.4, 1.65), (0.14, 5.2, 3.3), paint)
box("Wall east north of window", (7.05, 4.55, 1.65), (0.14, 4.9, 3.3), paint)
box("Wall east beneath window", (7.05, 0.65, 0.4), (0.14, 2.9, 0.8), paint)
box("Wall east above window", (7.05, 0.65, 3.1), (0.14, 2.9, 0.4), paint)
box("Wall north west of staff door", (-1.27, 7.05, 1.65), (11.66, 0.14, 3.3), paint)
box("Wall north east of staff door", (6.42, 7.05, 1.65), (1.36, 0.14, 3.3), paint)
box("Wall north above staff door", (5.15, 7.05, 2.78), (1.18, 0.14, 1.04), paint)
box("Wall south", (0, -6.05, 1.65), (14.2, 0.14, 3.3), paint)
for x in (-6.98, 6.98):
    box("Perimeter skirting", (x, 0.5, 0.065), (0.028, 13, 0.13), trim)
box("Perimeter skirting", (0, -5.98, 0.065), (14, 0.028, 0.13), trim)
box("Perimeter skirting", (-1.22, 6.98, 0.065), (11.56, 0.028, 0.13), trim)
box("Perimeter skirting", (6.37, 6.98, 0.065), (1.26, 0.028, 0.13), trim)
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
for x in (4.575, 5.725):
    box("Wall staff door jamb", (x, 6.94, 1.13), (0.08, 0.11, 2.26), trim, 0.008)
box("Wall staff door lintel", (5.15, 6.94, 2.22), (1.2, 0.11, 0.08), trim, 0.008)
staff_door = marker("ServiceDoor", (0, 0, 0), "staff_door", True)
box("Service door leaf", (5.15, 6.865, 1.1), (1.06, 0.05, 2.16), keyboard_mat, 0.006, staff_door)
box("Service door lever", (5.57, 6.82, 1.03), (0.18, 0.038, 0.027), steel, 0.008, staff_door)
label("Door placard", "STAFF ONLY", (5.15, 6.824, 1.7), 0.065, black, parent=staff_door)
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
for y in (-0.8, 2.1):
    box("Window vertical frame", (6.99, y, 1.85), (0.16, 0.055, 2.16), trim, 0.004)
for z in (0.8, 2.9):
    box("Window horizontal frame", (6.99, 0.65, z), (0.16, 2.94, 0.055), trim, 0.004)
box("Window sill", (6.89, 0.65, 0.79), (0.31, 3.0, 0.045), trim, 0.008)
glass = material("Clear sealed safety glass", (0.64, 0.76, 0.72), 0.12)
glass.diffuse_color = (0.64, 0.76, 0.72, 0.025)
glass.node_tree.nodes["Principled BSDF"].inputs["Alpha"].default_value = 0.025
glass.surface_render_method = "DITHERED"
box("Window safety glass", (7.015, 0.65, 1.85), (0.016, 2.84, 2.04), glass)

cork = material("Faded bulletin board cork", (0.32, 0.29, 0.20), 0.94)
box("Workplace bulletin board", (6.925, -2.7, 1.7), (0.085, 1.72, 1.27), cork, 0.008)
for y in (-3.58, -1.82):
    box("Bulletin board frame", (6.864, y, 1.7), (0.06, 0.035, 1.31), trim)
for z in (1.045, 2.355):
    box("Bulletin board frame", (6.864, -2.7, z), (0.06, 1.79, 0.035), trim)
notice_mat = texture_material("Perimeter retention installation notice", "workplace_notice.png", 0.94)
surface("WorkplaceNotice", (6.869, -2.25, 1.71), 0.72, 0.96, notice_mat, rotation=(math.pi / 2, 0, -math.pi / 2))
shift_mat = texture_material("Extended shift policy", "shift_notice.png", 0.94)
surface("Extended shift coverage notice", (6.865, -3.11, 1.79), 0.53, 0.729, shift_mat, rotation=(math.pi / 2, 0, -math.pi / 2))
for y in (-2.25, -3.11):
    box("Bulletin notice pin", (6.857, y, 2.185), (0.015, 0.018, 0.018), black, 0.003)
label("Floor wayfinding", "OPERATIONS   /   04", (-6.945, -3.9, 1.6), 0.075, trim, rotation=(math.pi / 2, 0, math.pi / 2))

# Staff circulation beyond the existing door. Blender Z becomes Godot Y.
current_collection = collections["08_Building"]
box("Floor break room", (0.3, 10.0, -0.09), (6, 6.1, 0.18), carpet)
box("Floor upper lobby", (5.15, 10.0, -0.09), (3.7, 6.0, 0.18), carpet)
box("Ceiling backing break room", (0.3, 10.0, 3.34), (6, 6.1, 0.10), ceiling)
box("Ceiling backing upper lobby", (5.15, 10.0, 3.34), (3.7, 6.1, 0.10), ceiling)
box("Wall break room west", (-2.77, 10.05, 1.65), (0.14, 5.9, 3.3), paint)
box("Wall upper lobby east", (7.07, 10.05, 1.65), (0.14, 5.9, 3.3), paint)
box("Wall break room north", (0.575, 13.07, 1.65), (6.55, 0.14, 3.3), paint)
box("Wall break room entry south", (3.3, 7.95, 1.65), (0.14, 1.7, 3.3), paint)
box("Wall break room entry north", (3.3, 11.725, 1.65), (0.14, 2.55, 3.3), paint)
box("Wall break room entry header", (3.3, 9.625, 2.85), (0.14, 1.65, 0.9), paint)
label("Break room sign", "BREAK ROOM", (3.39, 9.625, 2.66), 0.16, black, rotation=(math.pi / 2, 0, math.pi / 2))
label("Break room courtesy", "THANK YOU FOR REMAINING AVAILABLE", (0.3, 12.989, 2.1), 0.105, trim)
box("Building solid refreshment counter", (-0.9, 12.46, 0.45), (3.1, 0.78, 0.9), trim, 0.015)
box("Building solid counter top", (-0.9, 12.46, 0.923), (3.2, 0.85, 0.046), laminate, 0.01)
box("Building solid refrigerator", (2.25, 12.41, 0.95), (0.78, 0.95, 1.9), keyboard_mat, 0.025)
box("Refrigerator door seam", (2.25, 11.924, 1.3), (0.75, 0.016, 0.012), trim)
box("Refrigerator handle", (1.97, 11.9, 1.08), (0.04, 0.045, 0.3), steel, 0.006)
box("Building solid break table top", (-0.9, 9.8, 0.77), (1.65, 1.05, 0.07), laminate, 0.015)
for x in (-1.55, -0.25):
    for y in (9.42, 10.18):
        box("Building solid break table leg", (x, y, 0.36), (0.055, 0.055, 0.72), steel)
for y in (8.85, 10.75):
    box("Building solid break bench", (-0.9, y, 0.43), (1.7, 0.42, 0.10), chair_fabric, 0.015)
    for x in (-1.55, -0.25):
        box("Building solid bench support", (x, y, 0.19), (0.07, 0.36, 0.38), steel)
cylinder("Break room kettle", (-1.6, 12.4, 1.11), 0.13, 0.32, steel, 24)
box("Kettle handle", (-1.76, 12.4, 1.13), (0.06, 0.14, 0.2), black, 0.02)
for x in (-0.8, -0.5):
    cylinder("Break room mug", (x, 12.37, 1.0), 0.048, 0.11, ceramic, 24)

# Two enclosed cab interiors provide one local descent/return, not a tower simulation.
for floor_z, landing in ((0, "upper"), (-6, "lower")):
    box(f"Floor elevator {landing}", (5.15, 14.43, floor_z - 0.09), (2.6, 2.86, 0.18), trim)
    box(f"Ceiling backing elevator {landing}", (5.15, 14.43, floor_z + 3.04), (2.6, 2.86, 0.10), trim)
    # Start behind the painted jambs so steel/paint faces do not share a plane.
    for x in (3.78, 6.52):
        box(f"Wall elevator {landing} side", (x, 14.50, floor_z + 1.5), (0.14, 2.72, 3), steel)
    box(f"Wall elevator {landing} back", (5.15, 15.93, floor_z + 1.5), (2.88, 0.14, 3), steel)
    for x in (4.15, 6.15):
        box(f"Wall elevator {landing} front", (x, 13.07, floor_z + 1.5), (0.6, 0.14, 3), trim)
    box(f"Wall elevator {landing} header", (5.15, 13.07, floor_z + 2.65), (1.4, 0.14, 0.7), trim)
    box(f"Wall {landing} lobby north east", (6.725, 13.07, floor_z + 1.65), (0.55, 0.14, 3.3), paint)
    box(f"Elevator {landing} control", (5.15, 15.82, floor_z + 1.35), (0.22, 0.055, 0.28), black, 0.01)
    label(f"Elevator {landing} button label", "DOWN" if landing == "upper" else "UP", (5.15, 15.782, floor_z + 1.35), 0.06, green_led)
    label(f"Elevator {landing} destination", "LOWER / EXIT" if landing == "upper" else "OPERATIONS / 04", (5.15, 15.77, floor_z + 1.85), 0.105, paper)
    label(f"Elevator {landing} lintel sign", "SERVICE LIFT", (5.15, 12.985, floor_z + 2.68), 0.14, paper)
    marker(f"Elevator{landing.title()}Arrival", (5.15, 14.43, floor_z), "elevator_landing")
    box(f"Elevator {landing} diffuser", (5.15, 14.43, floor_z + 2.98), (1.0, 0.4, 0.025), cold_light)
    area_light(f"Elevator {landing} illumination", (5.15, 14.43, floor_z + 2.94), (5.15, 14.43, floor_z), 65, (0.76, 0.88, 0.84), 1.0, 0.4)

box("Floor lower landing", (5.15, 10.56, -6.09), (3.7, 4.88, 0.18), carpet)
box("Ceiling backing lower landing", (5.15, 10.56, -2.66), (3.7, 4.92, 0.10), ceiling)
box("Wall lower landing east", (7.07, 10.56, -4.35), (0.14, 4.92, 3.3), paint)
box("Wall lower landing south", (5.15, 8.13, -4.35), (3.7, 0.14, 3.3), paint)
box("Wall lower landing north west", (3.575, 13.07, -4.35), (0.55, 0.14, 3.3), paint)
box("Wall lower landing west short", (3.23, 12.44, -4.35), (0.14, 1.28, 3.3), paint)
label("Lower landing wayfinding", "EXIT  <", (5.15, 8.211, -4.15), 0.2, green_led, rotation=(math.pi / 2, 0, math.pi))

# The lower corridor is intentionally long; its uninterrupted center lane remains clear.
box("Floor exit corridor", (-22.7, 10.0, -6.09), (52, 3.6, 0.18), carpet)
box("Ceiling backing exit corridor", (-22.7, 10.0, -2.66), (52, 3.6, 0.10), ceiling)
for y in (8.13, 11.87):
    box("Wall exit corridor side", (-22.7, y, -4.35), (52, 0.14, 3.3), paint)
    box("Corridor skirting", (-22.7, y + (0.085 if y < 10 else -0.085), -5.93), (52, 0.028, 0.13), trim)
box("Wall exit end", (-48.77, 10.0, -4.35), (0.14, 3.88, 3.3), paint)
box("Exit door frame", (-48.67, 10.0, -4.83), (0.1, 1.75, 2.34), trim)
box("Exit door leaf", (-48.6, 10.0, -4.89), (0.055, 1.6, 2.2), keyboard_mat, 0.006)
box("Exit push bar", (-48.54, 10.0, -4.93), (0.055, 1.24, 0.05), steel, 0.008)
label("Exit sign", "EXIT", (-48.53, 10.0, -3.3), 0.28, green_led, rotation=(math.pi / 2, 0, math.pi / 2))
for x in (-5, -17, -29, -41):
    label("Corridor exit direction", "EXIT  <", (x, 11.788, -4.3), 0.15, green_led)
for x, y, z, power in ((0.3, 10.4, 3.2, 95), (5.15, 9.8, 3.2, 75), (5.15, 10.4, -2.8, 85)):
    box("Building fluorescent housing", (x, y, z), (1.3, 0.42, 0.065), trim)
    box("Building fluorescent diffuser", (x, y, z - 0.04), (1.23, 0.35, 0.01), cold_light)
    area_light("Building illumination", (x, y, z - 0.08), (x, y, z - 3), power, (0.76, 0.88, 0.84), 1.18, 0.32)
for index, x in enumerate(range(-1, -49, -6)):
    box("Corridor fluorescent housing", (x, 10, -2.8), (1.3, 0.42, 0.065), trim)
    box("Corridor fluorescent diffuser", (x, 10, -2.84), (1.23, 0.35, 0.01), warm_light if index % 3 == 0 else cold_light)
    area_light("Corridor illumination", (x, 10, -2.88), (x, 10, -6), 90, (0.84, 0.88, 0.76), 1.18, 0.32)

# A narrow, faceless service court makes the exterior feel like more of the workplace.
current_collection = collections["07_Exterior"]
concrete = material("Weathered exterior concrete", (0.105, 0.125, 0.117), 0.95)
netting = material("Retention net woven cord", (0.29, 0.33, 0.28), 0.86)
outside_window = material("Exterior dark office glass", (0.011, 0.028, 0.030), 0.32)
occupied_window = material("Exterior fluorescent office glass", (0.29, 0.40, 0.36), 0.75, emission=0.7)
dim_window = material("Exterior dim office glass", (0.095, 0.125, 0.098), 0.75, emission=0.22)
box("Opposing office facade", (17.5, 0.5, -7.2), (0.5, 24, 28), concrete)
for y in (-11.5, 12.5):
    box("Service court side facade", (12.25, y, -7.2), (10.5, 0.5, 28), concrete)
box("Court floor far below", (12.25, 0.5, -21.2), (10.5, 24, 0.4), concrete)
rng = random.Random(74)
for floor in range(8):
    z = 4.4 - floor * 3.15
    box("Opposing facade floor seam", (17.236, 0.5, z - 1.03), (0.025, 24, 0.07), trim)
    for bay in range(12):
        y = -10.45 + bay * 1.95
        window_mat = rng.choices((outside_window, dim_window, occupied_window), weights=(5, 2, 3))[0]
        box("Opposing office window", (17.235, y, z), (0.035, 1.36, 1.79), window_mat)
        box("Opposing office mullion", (17.202, y, z), (0.022, 0.025, 1.79), trim)
        box("Opposing window sill", (17.18, y, z - 0.92), (0.15, 1.49, 0.08), concrete)

def retention_net(name, height):
    # One mesh carries the full sagging lattice, rather than hundreds of separate ropes.
    columns, rows = 16, 36
    verts = []
    for row in range(rows + 1):
        v = row / rows
        for column in range(columns + 1):
            u = column / columns
            verts.append((7.18 + 5.25 * u, -5.65 + 12.15 * v,
                          height - 0.85 * math.sin(math.pi * u) * math.sin(math.pi * v)))
    faces = []
    for row in range(rows):
        for column in range(columns):
            a = row * (columns + 1) + column
            faces.append((a, a + 1, a + columns + 2, a + columns + 1))
    mesh = bpy.data.meshes.new(name)
    mesh.from_pydata(verts, [], faces)
    obj = bpy.data.objects.new(name, mesh)
    current_collection.objects.link(obj)
    obj.data.materials.append(netting)
    weave = obj.modifiers.new("Woven retention lattice", "WIREFRAME")
    weave.thickness = 0.019
    weave.use_even_offset = True
    weave.use_boundary = True
    for x in (7.18, 12.43):
        rod(name + " edge cable", (x, -5.65, height), (x, 6.5, height), 0.034, steel)
    for y in (-5.65, 6.5):
        rod(name + " end cable", (7.18, y, height), (12.43, y, height), 0.034, steel)
    for y in (-5.65, -2.6, 0.425, 3.45, 6.5):
        rod(name + " support bracket", (7.10, y, height - 0.7), (12.43, y, height), 0.055, steel)
    return obj

retention_net("Perimeter retention net upper", -0.95)
retention_net("Perimeter retention net lower", -4.10)
area_light("Service court reflected light", (10.1, 0.5, 4.1), (10.1, 0.5, -1.6), 45, (0.48, 0.64, 0.58), 5.0)

# Two review cameras; the primary view is at standing player eye level.
current_collection = collections["05_Cameras"]
def camera(name, location, target, lens):
    data = bpy.data.cameras.new(name)
    data.lens = lens
    data.clip_start = 0.04
    data.clip_end = 90
    obj = bpy.data.objects.new(name, data)
    current_collection.objects.link(obj)
    obj.location = location
    obj.rotation_euler = (Vector(target) - obj.location).to_track_quat("-Z", "Y").to_euler()
    return obj

cubicle_camera = camera("Cubicle review", (-2.5, -3.67, 1.64), (-2.65, -1.60, 1.18), 23)
room_camera = camera("Office review", (5.7, -5.48, 2.12), (-1.6, 1.0, 1.45), 24)
outside_camera = camera("Exterior review", (6.65, 0.62, 1.64), (9.5, 0.62, -1.7), 20)
notice_camera = camera("Workplace notice review", (5.05, -2.71, 1.70), (6.869, -2.70, 1.70), 30)
break_camera = camera("Break room review", (2.65, 8.9, 1.64), (-0.6, 11.0, 1.35), 20)
elevator_camera = camera("Elevator review", (5.15, 11.35, 1.64), (5.15, 15.82, 1.5), 23)
corridor_camera = camera("Corridor review", (2.7, 10, -4.36), (-48.6, 10, -4.5), 23)
exit_camera = camera("Exit review", (-45.5, 10, -4.36), (-48.6, 10, -4.7), 23)
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
for review_camera, name in ((cubicle_camera, "cubicle"), (room_camera, "office"), (outside_camera, "exterior"), (notice_camera, "workplace_notice"), (break_camera, "break_room"), (elevator_camera, "elevator"), (corridor_camera, "corridor"), (exit_camera, "exit")):
    scene.camera = review_camera
    scene.render.filepath = str(PREVIEWS / f"{name}.png")
    bpy.ops.render.render(write_still=True)
scene.camera = cubicle_camera
scene.render.filepath = str(PREVIEWS / "cubicle.png")
bpy.ops.wm.save_as_mainfile(filepath=str(SOURCE))
print(f"OFFICE_ASSET_READY: {SOURCE}\nGODOT_EXPORT: {EXPORT}")
