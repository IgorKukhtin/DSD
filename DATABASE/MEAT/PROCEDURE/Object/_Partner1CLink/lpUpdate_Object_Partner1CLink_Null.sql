-- Function: lpUpdate_Object_Partner1CLink_Null (Integer, TVarChar)

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner1CLink_Null (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner1CLink_Null(
    IN inCode                   Integer,    -- Код объекта
    IN inPartnerId              Integer,    -- 
    IN inBranchId               Integer    -- 
)
  RETURNS VOID
AS
$BODY$
DECLARE 
  vbObjectLinkId Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner1CLink());

       SELECT Object_Partner1CLink.Id INTO vbObjectLinkId

       FROM Object AS Object_Partner1CLink
            JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                 ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()

            JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                 ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
       
       WHERE ObjectLink_Partner1CLink_Partner.ChildObjectId = inPartnerId 
         AND ObjectLink_Partner1CLink_Branch.ChildObjectId = inBranchId
         AND Object_Partner1CLink.ObjectCode = inCode;


   -- сохранили <Объект>
   UPDATE Object SET ObjectCode = 0 WHERE Id = vbObjectLinkId;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUpdate_Object_Partner1CLink_Null (Integer, Integer, Integer)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.06.14                        * 
*/
