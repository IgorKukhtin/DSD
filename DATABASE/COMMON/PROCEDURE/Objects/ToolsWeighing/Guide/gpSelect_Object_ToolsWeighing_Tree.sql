-- Function: gpSelect_Object_ToolsWeighing_Tree()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_Tree (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_Tree (
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               BranchCode Integer, ParentId Integer, isErased boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ToolsWeighing());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
       SELECT
             Object_ToolsWeighing_View.Id
           , Object_ToolsWeighing_View.Code

           , CASE WHEN Object_ToolsWeighing_View.Name = 'Scale_1'
                       THEN 'Экспедиция - (001)Филиал Днепр'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_101'
                       THEN 'Экспедиция - (101) Инвентаризация' -- || COALESCE (Object_ToolsWeighing_View.BranchCode :: TVarChar, '???')

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_201'
                       THEN 'Экспедиция - (201)Сырье'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_205'
                       THEN 'Экспедиция - (205)Ирна'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_301'
                       THEN 'Экспедиция - (301)Склад специй'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_302'
                       THEN 'Экспедиция - (302)Склад запчастей'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_303'
                       THEN 'Экспедиция - (303)Склад спецодежды'

                  --
                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_1'
                       THEN 'Производство - (001)Склад Реализации'

                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_101'
                       THEN 'Производство - (101)Склад База ГП'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_102'
                       THEN 'Производство - (102)ЦЕХ колбасный'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_103'
                       THEN 'Производство - (103)ЦЕХ Тушенки'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_104'
                       THEN 'Производство - (104)ЦЕХ Упаковки (маркировка+сортировка)'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_105'
                       THEN 'Производство - (105)Склад База ГП (инвентаризация)'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_106'
                       THEN 'Производство - (106)Лакирование'

                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_111'
                       THEN 'Производство - (111)Склад База ГП - Инвентаризация'
                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_112'
                       THEN 'Производство - (112)Склад Реализации - Инвентаризация'
                  --
                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_201'
                       THEN 'Производство - (201)Сырье - Склад'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_202'
                       THEN 'Производство - (202)Сырье - Бойня'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_301'
                       THEN 'Производство - (301)Склад специй'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_302'
                       THEN 'Производство - (302)Склад запчастей'
                       
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_303'
                       THEN 'Производство - (303)Склад спецодежды'

                  WHEN POSITION ('Scale_' IN Object_ToolsWeighing_View.Name) = 1
                   AND Object_ToolsWeighing_View.BranchCode > 0
                   AND Object_ToolsWeighing_View.BranchCode < 1000
                       THEN 'Экспедиция - ' || '(' || CASE WHEN Object_ToolsWeighing_View.BranchCode < 10 THEN '00' WHEN Object_ToolsWeighing_View.BranchCode < 100 THEN '0' ELSE '' END
                                            || Object_ToolsWeighing_View.BranchCode :: TVarChar || ')'
                                            || COALESCE ((SELECT Object.ValueData FROM Object
                                                          WHERE Object.DescId = zc_Object_Branch() AND Object.ObjectCode = Object_ToolsWeighing_View.BranchCode)
                                                       , Object_ToolsWeighing_View.Name)

                  WHEN POSITION ('Scale_' IN Object_ToolsWeighing_View.Name) = 1
                   AND Object_ToolsWeighing_View.BranchCode > 1000
                       THEN 'Этикетки - ' || '(' || CASE WHEN Object_ToolsWeighing_View.BranchCode - 1000 < 10 THEN '00' WHEN Object_ToolsWeighing_View.BranchCode - 1000 < 100 THEN '0' ELSE '' END
                                          || (Object_ToolsWeighing_View.BranchCode - 1000) :: TVarChar || ')'
                                          || COALESCE ((SELECT Object.ValueData FROM Object
                                                        WHERE Object.DescId = zc_Object_Branch() AND Object.ObjectCode = Object_ToolsWeighing_View.BranchCode - 1000)
                                                     , Object_ToolsWeighing_View.Name)

                  ELSE Object_ToolsWeighing_View.Name

             END :: TvarChar AS Name

           , Object_ToolsWeighing_View.BranchCode
           , COALESCE (Object_ToolsWeighing_View.ParentId, 0) AS ParentId
           , Object_ToolsWeighing_View.isErased

       FROM (SELECT Object_ToolsWeighing_View.*
                  , CASE WHEN POSITION ('Scale_' IN Object_ToolsWeighing_View.Name) = 1
                              THEN zfConvert_StringToNumber (SUBSTRING (Object_ToolsWeighing_View.Name
                                                             FROM LENGTH ('Scale_') + 1
                                                             FOR LENGTH (Object_ToolsWeighing_View.Name) - LENGTH ('Scale_')
                                                            ))
                         WHEN POSITION ('ScaleCeh_' IN Object_ToolsWeighing_View.Name) = 1
                              THEN zfConvert_StringToNumber (SUBSTRING (Object_ToolsWeighing_View.Name
                                                             FROM LENGTH ('ScaleCeh_') + 1
                                                             FOR LENGTH (Object_ToolsWeighing_View.Name) - LENGTH ('ScaleCeh_')
                                                            ))
                         ELSE 0
                    END :: Integer AS BranchCode
             FROM Object_ToolsWeighing_View
             WHERE Object_ToolsWeighing_View.isLeaf = FALSE
            ) AS Object_ToolsWeighing_View

      UNION ALL
       SELECT
             0 AS Id,
             0 AS Code,
             CAST('ВСЕ' AS TVarChar) AS Name,
             0 AS BranchCode,
             0 AS ParentId,
             FALSE AS isErased
       ORDER BY 4, 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.03.14                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ToolsWeighing_Tree ('2') WHERE ParentId = 0 ORDER BY 3
