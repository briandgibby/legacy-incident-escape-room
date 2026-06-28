create schema if not exists marketing;

create table marketing.coupon_rules (
  code text primary key,
  channel text not null check (channel in ('web', 'mobile')),
  starts_at timestamptz not null,
  expires_at timestamptz not null,
  discount_percent numeric(5, 2),
  discount_basis_points integer,
  constraint coupon_has_discount check (
    discount_percent is not null
    or discount_basis_points is not null
  )
);

comment on column marketing.coupon_rules.discount_percent is
  'Legacy whole-number percent field kept for rollback.';

comment on column marketing.coupon_rules.discount_basis_points is
  'Migrated discount field. 1500 means 15 percent.';
