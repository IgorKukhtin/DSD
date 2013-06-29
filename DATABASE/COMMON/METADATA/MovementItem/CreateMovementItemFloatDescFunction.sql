--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ÕŒ¬¿ﬂ —’≈Ã¿ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementItemFloat_AmountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_AmountPartner'); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_MovementItemFloat_AmountPacker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_AmountPacker'); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_MovementItemFloat_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_Price'); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_MovementItemFloat_CountForPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_CountForPrice'); END; $BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION zc_MovementItemFloat_LiveWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_LiveWeight'); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_MovementItemFloat_HeadCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_HeadCount'); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_MovementItemFloat_RealWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_RealWeight'); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_MovementItemFloat_Count() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_Count'); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_MovementItemFloat_CuterCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_CuterCount'); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_MovementItemFloat_AmountReceipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_AmountReceipt'); END; $BODY$ LANGUAGE plpgsql;



/*-------------------------------------------------------------------------------
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 29.06.13                                        * ÕŒ¬¿ﬂ —’≈Ã¿
 29.06.13                                        * zc_MovementItemFloat_AmountPacker
*/
