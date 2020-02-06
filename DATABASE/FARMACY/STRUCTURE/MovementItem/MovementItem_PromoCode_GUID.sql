-- DROP TABLE IF EXISTS MovementItem_PromoCode_GUID;
/*
CREATE TABLE MovementItem_PromoCode_GUID (
  MovementItemId      Integer,    -- ID товара

  GUID                TVarChar,   -- GUID

  CONSTRAINT MovementItem_PromoCode_GUID_pkey PRIMARY KEY(MovementItemId)
);

CREATE UNIQUE INDEX idx_MovementItem_PromoCode_GUID_valuedata_GUID_MovementItemId ON public.MovementItem_PromoCode_GUID
  USING btree (GUID COLLATE pg_catalog."default", MovementItemId);

CREATE UNIQUE INDEX idx_MovementItem_PromoCode_GUID_valuedata_MovementItemId_GUID ON public.MovementItem_PromoCode_GUID
  USING btree (MovementItemId, GUID COLLATE pg_catalog."default");

select * from MovementItem_PromoCode_GUID

*/