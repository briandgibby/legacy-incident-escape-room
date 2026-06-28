select
  code,
  channel,
  discount_percent,
  discount_basis_points,
  starts_at,
  expires_at
from marketing.coupon_rules
where code in ('LATE-NIGHT-15', 'WELCOME10')
order by code;
