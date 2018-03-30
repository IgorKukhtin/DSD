
DROP FUNCTION IF EXISTS gpInsertUpdate_GlobalConst_IncomeKoeff (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_GlobalConst_IncomeKoeff(
    IN inIncomeKoeff     TFloat,       -- коэфф. для прихода поставщика
    IN inSession         TVarChar      -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE dd       TVarChar;
  DECLARE vbStr    TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   -- 
   dd := '$';
   vbStr:= 'CREATE OR REPLACE FUNCTION zc_Enum_GlobalConst_IncomeKoeff() RETURNS TFloat AS ' ||dd||'BODY'||dd||' BEGIN RETURN ( SELECT '|| inIncomeKoeff  || ' ::TFloat); END; '||dd||'BODY'||dd||' LANGUAGE PLPGSQL IMMUTABLE;' ;
   PERFORM lfExecSql (vbStr);
--return vbStr;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
28.03.18          *
*/
-- тест
-- SELECT * FROM gpInsertUpdate_GlobalConst_IncomeKoeff(inIncomeKoeff:= 44::Tfloat , inSession:= '3' ::TVarChar)

--SELECT zc_Enum_GlobalConst_IncomeKoeff()