-- DROP TABLE IF EXISTS MovementItem_Loyalty_GUID;
/*
CREATE TABLE MovementItem_Loyalty_GUID (
  MovementItemId      Integer,    -- ID товара

  GUID                TVarChar,   -- GUID

  CONSTRAINT MovementItem_Loyalty_GUID_pkey PRIMARY KEY(MovementItemId)
);

CREATE UNIQUE INDEX idx_MovementItem_Loyalty_GUID_valuedata_GUID_MovementItemId ON public.MovementItem_Loyalty_GUID
  USING btree (GUID COLLATE pg_catalog."default", MovementItemId);

CREATE UNIQUE INDEX idx_MovementItem_Loyalty_GUID_valuedata_MovementItemId_GUID ON public.MovementItem_Loyalty_GUID
  USING btree (MovementItemId, GUID COLLATE pg_catalog."default");

select * from MovementItem_Loyalty_GUID

*/