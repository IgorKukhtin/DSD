CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Role()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectLink_RoleRight_Role()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectLink_RoleRight_Process()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectLink_RoleRight_Process()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_Role()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectLink_UserRole_Role()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserRole_User()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 4;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Currency()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 5;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_PaidKind()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 6;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Branch()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 7;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_JuridicalGroup_Parent()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 8;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_JuridicalGroup()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 9;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Juridical_GoodsProperty()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 10;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Partner_Juridical()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 11;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Branch_Juridical()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 12;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_UnitGroup()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 13;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Unit_Branch()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 14;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_UnitGroup_Parent()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 15;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Bank_Juridical()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 16;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsGroup_Parent()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 17;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_GoodsGroup()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 18;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_Measure()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 19;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Juridical()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 20;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Bank()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 21;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_BankAccount_Currency()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 22;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Cash_Branch()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 23;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 24;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_Goods()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 25;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_GoodsPropertyValue_GoodsKind()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 26;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountGroup()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 27;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_AccountDirection()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 28;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Account_InfoMoneyDestination()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 29;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_Goods_InfoMoney()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 30;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserFormSettings_User()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 31;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_UserFormSettings_Form()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 32;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceListItem_PriceList()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 33;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ObjectLink_PriceListItem_Goods()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 34;
END;  $BODY$ LANGUAGE plpgsql;
