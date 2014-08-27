-- Function: gpInsert_Object_Partner1CLink (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_Partner1CLink (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_Partner1CLink(
    IN inBranchTopId            Integer,    -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_Object_Partner1CLink());
   vbUserId := lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inBranchTopId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <Филиал>.';
   END IF;


   -- сохраняем всех
   PERFORM lpInsertUpdate_Object_Partner1CLink (ioId         := 0
                                              , inCode       := Sale1C.ClientCode
                                              , inName       := Sale1C.ClientName
                                              , inPartnerId  := NULL
                                              , inBranchId   := inBranchTopId
                                              , inContractId := NULL
                                              , inUserId     := vbUserId)
   FROM (SELECT Sale1C.ClientCode, Sale1C.ClientName
         FROM Sale1C
         WHERE zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc)) = inBranchTopId
           AND Sale1C.ClientCode <> 0
         GROUP BY Sale1C.ClientCode, Sale1C.ClientName
        ) AS Sale1C
        LEFT JOIN (SELECT Object_Partner1CLink.ObjectCode
                        , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                   FROM Object AS Object_Partner1CLink
                        LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                             ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                            AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                   WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                     AND Object_Partner1CLink.ObjectCode <> 0
                  ) AS tmpPartner1CLink ON tmpPartner1CLink.BranchId = inBranchTopId
                                       AND tmpPartner1CLink.ObjectCode = Sale1C.ClientCode
   WHERE tmpPartner1CLink.ObjectCode IS NULL;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsert_Object_Partner1CLink (Integer, TVarChar)  OWNER TO postgres;
  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.08.14                                        *
*/
