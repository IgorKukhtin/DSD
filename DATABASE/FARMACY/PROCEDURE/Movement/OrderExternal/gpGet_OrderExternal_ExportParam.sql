-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_OrderExternal_ExportParam(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderExternal_ExportParam(
    IN inMovementId  Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS TABLE (DefaultFileName TVarChar, ExportType Integer) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbUnitName TVarChar;
  DECLARE vbSubject TVarChar;
  DECLARE vbMainJuridicalName TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);


   -- определяем
   SELECT FromId
        , REPLACE (REPLACE (ToName, '/', '_'), '\', '_'), Object_Unit_View.JuridicalName
          INTO vbJuridicalId
             , vbUnitName
             , vbMainJuridicalName
   FROM Movement_OrderExternal_View 
        LEFT JOIN Object_Unit_View ON Object_Unit_View.Id = ToId
   WHERE Movement_OrderExternal_View.Id = inMovementId;

       
   -- Оптима
   IF vbJuridicalId = 59611
   THEN 
       -- определяем
       SELECT REPLACE(REPLACE(Object_ImportExportLink_View.StringKey, '|', ''), '*', ' ')
              INTO vbSubject
       FROM MovementLinkObject 
            LEFT JOIN MovementLinkObject AS UnitLink ON UnitLink.DescId = zc_MovementLinkObject_To()
                                                    AND UnitLink.movementid = MovementLinkObject.MovementId
            LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = UnitLink.objectid
                                                  AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_ClientEmailSubject()
                                                   AND Object_ImportExportLink_View.ValueId = MovementLinkObject.ObjectId  
 
       WHERE MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
         AND MovementLinkObject.MovementId = inMovementId;

       -- Результат - ДЛЯ Оптима
       RETURN QUERY
         SELECT COALESCE(vbSubject, ('Заказ - ' || COALESCE (vbMainJuridicalName, '') || ' от ' || COALESCE (vbUnitName, ''))) :: TVarChar
              , 5 AS ExportType
               ;

       -- !!!выход!!!
       RETURN;

   END IF;


   -- БАДМ
   IF vbJuridicalId = 59610
   THEN
       -- Результат - ДЛЯ БАДМ
       RETURN QUERY
         SELECT ('Заказ - ' || COALESCE (vbMainJuridicalName, '') || ' от ' || COALESCE (vbUnitName, '')) :: TVarChar
               , 5 AS ExportType
                ;

       -- !!!выход!!!
       RETURN;

   END IF;
   

   -- ВЕНТА
   IF vbJuridicalId = 59612
   THEN 
       SELECT REPLACE(REPLACE(Object_ImportExportLink_View.StringKey, '|', ''), '*', ' ') INTO vbSubject
       FROM MovementLinkObject AS MLO_From
                 LEFT JOIN MovementLinkObject AS MLO_To 
                                              ON MLO_To.DescId     = zc_MovementLinkObject_To()
                                             AND MLO_To.MovementId = MLO_From.MovementId
                 LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId     = MLO_To.objectid
                                                       AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_ClientEmailSubject()
                                                       AND Object_ImportExportLink_View.ValueId    = MLO_From.ObjectId  
       WHERE MLO_From.DescId     = zc_MovementLinkObject_From()
         AND MLO_From.MovementId = inMovementId;

       -- Результат - ДЛЯ ВЕНТА
       RETURN QUERY
         SELECT COALESCE(vbSubject, ('Заказ - '||COALESCE(vbMainJuridicalName, '')||' от '||COALESCE(vbUnitName, ''))) :: TVarChar
              , 3 AS ExportType
               ;

       -- !!!выход!!!
       RETURN;

   END IF;


   -- Результат - ДЛЯ ВСЕХ остальных
   RETURN QUERY
   SELECT
      ('Заказ - '||COALESCE(vbMainJuridicalName, '')||' от '||COALESCE(vbUnitName, ''))::TVarChar
    , 3 AS ExportType
     ;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OrderExternal_ExportParam(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.01.15                         *  
 16.12.14                         *  

*/

-- тест
-- SELECT * FROM gpGet_OrderExternal_ExportParam (8112483, '2')
