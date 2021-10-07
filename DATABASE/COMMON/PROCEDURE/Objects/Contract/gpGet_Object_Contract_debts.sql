-- Function: gpGet_Object_Contract_debts()

DROP FUNCTION IF EXISTS gpGet_Object_Contract_debts (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Contract_debts(
    IN inContractId        Integer  , -- ключ Документа
   OUT outAmount           TFloat   , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     outAmount := (SELECT SUM (Container.Amount) AS Amount
                   FROM ContainerLinkObject AS CLO_Contract
                        INNER JOIN Container ON Container.Id = CLO_Contract.ContainerId
                   WHERE CLO_Contract.ObjectId = inContractId -- 7222057 --4446280  --6291239  --16094 --CLO_Contract.ContainerId = Container.Id
                     AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                   HAVING SUM (Container.Amount) > 1 OR SUM (Container.Amount) < -1
                   ) :: TFloat;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.21         *
*/

-- тест
-- SELECT  * FROM gpGet_Object_Contract_debts (7222057,'5') ;