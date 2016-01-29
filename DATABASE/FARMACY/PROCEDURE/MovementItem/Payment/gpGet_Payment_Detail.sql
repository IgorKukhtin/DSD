-- Function: gpGet_Payment_Detail()

DROP FUNCTION IF EXISTS gpGet_Payment_Detail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Payment_Detail(
    IN inJuridicalId         Integer   , -- Ключ объекта <Юр лицо>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (BankAccountId Integer, CurrencyId Integer)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Payment());
    vbUserId := inSession;
    --проверили расчетный счет
    RETURN QUERY
        SELECT
            Object_BankAccount.Id
           ,Object_BankAccount.CurrencyId
        FROM
            Object_BankAccount_View AS Object_BankAccount
        WHERE
            JuridicalId = inJuridicalId
        LIMIT 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Payment_Detail (Integer, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 10.12.15                                                                         *
*/