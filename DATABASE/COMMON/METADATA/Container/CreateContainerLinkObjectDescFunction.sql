-- Справочник аналитик

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Account()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_ProfitLoss()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Business()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_JuridicalBasis()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 4;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_InfoMoney()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 5;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Unit()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 6;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Goods()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 7;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_GoodsKind()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 8;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_InfoMoneyDetail()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 9;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Contract()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 10;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PaidKind()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 11;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Juridical()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 12;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Car()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 13;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Position()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 14;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Personal()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 15;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalStore()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 16;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalBuyer()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 17;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalGoods()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 18;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalCash()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 19;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_AssetTo()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 20;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PartionGoods()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 21;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PartionMovement()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 22;
END;  $BODY$ LANGUAGE plpgsql;