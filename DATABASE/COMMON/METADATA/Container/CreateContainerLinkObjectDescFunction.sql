--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ÕŒ¬¿ﬂ —’≈Ã¿ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Account() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Account'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_ProfitLoss() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_ProfitLoss'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_InfoMoney() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoney'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Unit() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Unit'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Goods() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Goods'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_GoodsKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_GoodsKind'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_InfoMoneyDetail() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoneyDetail'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Contract() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Contract'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PaidKind() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PaidKind'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Juridical() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Juridical'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Car() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Car'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Position() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Position'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Personal() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Personal'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalStore() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalStore'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalBuyer() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalBuyer'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalGoods() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalGoods'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalCash() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalCash'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_AssetTo() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_AssetTo'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PartionGoods() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PartionGoods'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PartionMovement() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PartionMovement'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;


CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_JuridicalBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalSupplier() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalSupplier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 05.07.13          * ÔÂÂıÓ‰ ‚ÒÂ„Ó Ì‡ ÕŒ¬”ﬁ —’≈Ã”
 03.07.13                                        * ÕŒ¬¿ﬂ —’≈Ã¿
*/
