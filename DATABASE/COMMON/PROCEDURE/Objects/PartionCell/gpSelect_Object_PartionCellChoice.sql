-- Function: gpSelect_Object_PartionCell()

DROP FUNCTION IF EXISTS gpSelect_Object_PartionCellChoice (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PartionCellChoice (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionCellChoice(
    IN inIsShowFree         Boolean   ,
    IN inSession            TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_search TVarChar
             , Status TVarChar
                           
            
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());

      RETURN QUERY
      WITH
      tmpPartionCell AS (SELECT
                               Object.Id         AS Id
                             , Object.ObjectCode AS Code
                             , Object.ValueData  AS Name 
                             , (Object.ValueData ||'@'||REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (Object.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '')) :: TVarChar AS Name_search
                         FROM Object
                         WHERE Object.DescId = zc_Object_PartionCell() 
                           AND Object.isErased = FALSE
                         )
      -- занятые ячейки
     , tmpMILO_PartionCell AS (SELECT DISTINCT MovementItemLinkObject.ObjectId
                               FROM MovementItemLinkObject
                               WHERE MovementItemLinkObject.DescId IN (zc_MILinkObject_PartionCell_1()
                                                                     , zc_MILinkObject_PartionCell_2()
                                                                     , zc_MILinkObject_PartionCell_3()
                                                                     , zc_MILinkObject_PartionCell_4()
                                                                     , zc_MILinkObject_PartionCell_5()
                                                                      )
                                 AND MovementItemLinkObject.ObjectId > 0 
                                 AND inIsShowFree = TRUE
                               )

       --
       SELECT 
              Object.Id
            , Object.Code 
            , Object.Name 
            , Object.Name_search
            , CASE WHEN inIsShowFree = FALSE THEN ''
                   ELSE 
                       CASE WHEN COALESCE (tmpMILO_PartionCell.ObjectId,0) = 0 THEN 'Свободно' ELSE 'Занято' END
              END :: TVarChar AS Status

       FROM tmpPartionCell AS Object
           LEFT JOIN tmpMILO_PartionCell ON tmpMILO_PartionCell.ObjectId = Object.Id
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 19.03.23         *
*/

-- тест
--SELECT * FROM gpSelect_Object_PartionCellChoice (FALSE, zfCalc_UserAdmin())