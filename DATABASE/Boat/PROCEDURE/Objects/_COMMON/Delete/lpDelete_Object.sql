-- Function: lpDelete_Object(integer, tvarchar)

-- DROP FUNCTION lpDelete_Object(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_Object(
IN inId integer, 
IN Session tvarchar)
  RETURNS void AS
$BODY$
BEGIN

  IF (SELECT Object.DescId FROM Object WHERE Object.Id = inId) NOT IN (zc_Object_BankAccountPdf(), zc_Object_InvoicePdf(), zc_Object_ProductDocument())
  THEN
      RAISE EXCEPTION 'Ошибка.<%>', 'lpDelete_Object';
  ELSE
      -- Серьезный скрипт !!!НЕ ДЛЯ РАБОЧЕЙ БАЗЫ!!!
      DELETE FROM DefaultValue  WHERE UserKeyId = inId;
      DELETE FROM Container WHERE ObjectId = inId;
      DELETE FROM ContainerLinkObject WHERE ObjectId = inId;
      DELETE FROM ObjectLink WHERE ObjectId = inId;
      DELETE FROM ObjectLink WHERE ChildObjectId = inId;
      DELETE FROM ObjectString WHERE ObjectId = inId;
      DELETE FROM ObjectBLOB WHERE ObjectId = inId;
      DELETE FROM ObjectFloat WHERE ObjectId = inId;
      DELETE FROM ObjectProtocol WHERE ObjectId = inId;
      DELETE FROM ObjectBoolean WHERE ObjectId = inId;
      DELETE FROM ObjectDate WHERE ObjectId = inId;
      DELETE FROM Object WHERE Id = inId;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_Object(integer, tvarchar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.24          * zc_Object_BankAccountPdf()
 25.04.15                                        * Серьезный скрипт !!!НЕ ДЛЯ РАБОЧЕЙ БАЗЫ!!!
 01.01.14          *
*/
