-- Function: lpCheck_Movement_Status (Integer)

DROP FUNCTION IF EXISTS lpCheck_Movement_Status (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_Status(
    IN inMovementId        Integer  , -- ключ объекта <Документ>
    IN inUserId            Integer    -- Пользователь
)                              
  RETURNS VOID
AS
$BODY$
   DECLARE vbDescId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCloseDate TDateTime;
   DECLARE vbRoleId Integer;

   DECLARE vbDocumentTaxKindId Integer;
   DECLARE vbStatusId_Tax Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbDescName TVarChar;
   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbStartDate  TDateTime;
   DECLARE vbEndDate  TDateTime;
BEGIN


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheck_Movement_Status (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.10.14                                        * add zc_Enum_Role_Admin
 23.09.14                                        * add Object_Role_MovementDesc_View
 05.09.14                                        * add проверка - если входит в сводную, то она должна быть распроведена
*/

-- тест
-- SELECT * FROM lpCheck_Movement_Status (inMovementId:= 55, inUserId:= 2)
