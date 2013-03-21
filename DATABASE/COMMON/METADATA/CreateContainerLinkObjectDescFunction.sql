-- Справочник аналитик

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Goods()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Unit()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Cash()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 3;
END;  $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Account()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 4;
END;  $BODY$ LANGUAGE plpgsql;
