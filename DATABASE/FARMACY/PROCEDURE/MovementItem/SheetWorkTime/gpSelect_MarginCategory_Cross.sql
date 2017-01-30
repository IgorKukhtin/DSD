-- Function: gpSelect_MarginCategory_Cross()

DROP FUNCTION IF EXISTS gpSelect_MarginCategory_Cross(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MarginCategory_Cross(
 /*   IN inDate        TDateTime , --
    IN inUnitId      Integer   , --
    IN inisErased    Boolean   , --
*/
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor; 
          cur2 refcursor; 
          vbIndex Integer;
          vbUnitCount Integer;
          vbCrossString Text;
          vbQueryText Text;
          vbFieldNameText Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());


        -- Все подразделения
        CREATE TEMP TABLE _tmpUnitList(UnitId integer, NumUnit integer, UnitName TVarChar) ON COMMIT DROP;  /*tmpOperDate*/
        INSERT INTO _tmpUnitList(UnitId, NumUnit, UnitName)
             SELECT Object_Unit.Id                                    AS UnitId
                  , ROW_NUMBER() OVER (ORDER BY Object_Unit.Id)  ::integer      AS NumUnit
                  , Object_Unit.ValueData AS UnitName
             FROM Object AS Object_Unit
                  LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                       ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                      AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
             WHERE Object_Unit.DescId = zc_Object_Unit()
               AND Object_Unit.isErased = FALSE
               AND ObjectLink_Unit_Parent.ChildObjectId is not null;

        CREATE TEMP TABLE _tmpminPrice (minPrice Tfloat) ON COMMIT DROP; 
            INSERT INTO _tmpminPrice (minPrice)
                        SELECT DISTINCT ObjectFloat_MinPrice.ValueData AS minPrice 
                        FROM ObjectFloat AS ObjectFloat_MinPrice
                        WHERE ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice();
                    

     -- все категории наценок
     CREATE TEMP TABLE _tmpData (MarginCategoryItemId integer, UnitId integer, minPrice Tfloat, MarginPercent Tfloat, MarginCategoryId integer) ON COMMIT DROP; /*tmpMI */
     INSERT INTO _tmpData (MarginCategoryItemId, UnitId, minPrice, MarginPercent, MarginCategoryId)
    WITH
tmpMarginCategory AS (SELECT ObjectFloat_Percent.ObjectId AS MarginCategoryId 
                      FROM ObjectFloat AS ObjectFloat_Percent 	
                           INNER JOIN Object AS Object_MarginCategory
                              ON Object_MarginCategory.Id = ObjectFloat_Percent.ObjectId
                             AND Object_MarginCategory.DescId = zc_Object_MarginCategory()
                             AND Object_MarginCategory.isErased = FALSE
                      WHERE ObjectFloat_Percent.DescId = zc_ObjectFloat_MarginCategory_Percent()
                        AND ObjectFloat_Percent.ValueData  = 0
                      ORDER BY ObjectFloat_Percent.ObjectId
                      )
, tmpLink AS (SELECT Object_MarginCategoryLink_View.UnitId
                   , MAX (tmpMarginCategory.MarginCategoryId) AS MarginCategoryId
              FROM tmpMarginCategory
                   INNER JOIN Object_MarginCategoryLink_View ON Object_MarginCategoryLink_View.MarginCategoryId = tmpMarginCategory.MarginCategoryId
              GROUP BY  Object_MarginCategoryLink_View.UnitId
              )

 , tmpMarginCategoryItem AS (SELECT MAX (Object_MarginCategoryItem.Id)      AS Id
                                  , Object_MarginCategoryItem.MarginCategoryId
                                  , Object_MarginCategoryItem.MarginPercent
                                  , Object_MarginCategoryItem.minPrice
                             FROM Object_MarginCategoryItem_View AS Object_MarginCategoryItem 
                             GROUP BY Object_MarginCategoryItem.MarginCategoryId
                                  , Object_MarginCategoryItem.MarginPercent
                                  , Object_MarginCategoryItem.minPrice
                              )

SELECT tmpMarginCategoryItem.Id  
       , tmpLink.UnitId 
       , tmpMarginCategoryItem.minPrice 
       , tmpMarginCategoryItem.MarginPercent  
       , tmpMarginCategoryItem.MarginCategoryId

FROM tmpLink 
LEFT JOIN _tmpUnitList ON _tmpUnitList.UnitId =  tmpLink.UnitId 
LEFT JOIN tmpMarginCategoryItem ON tmpMarginCategoryItem.MarginCategoryId = tmpLink.MarginCategoryId;


     vbIndex := 1;
     -- кол-во подразделений
     vbUnitCount := (SELECT COUNT(*) FROM _tmpUnitList);

     vbCrossString := 'Key Integer[]';
     vbFieldNameText := '';
     -- строим строчку для кросса
     WHILE (vbIndex < 2) LOOP
       
       vbCrossString := vbCrossString || ', Unit' || vbIndex || ' VarChar[0]'; 
       vbFieldNameText := vbFieldNameText || ', Unit' || vbIndex || '[1] AS Value'||vbIndex||'  '||
                                             ', Unit' || vbIndex || '[2]::Integer  AS UnitId'||vbIndex||' ';
vbIndex := vbIndex + 1;
     END LOOP;


     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT _tmpUnitList.UnitId 
                        , _tmpUnitList.UnitName ::TVarChar AS ValueField
               FROM _tmpUnitList
                                                    
      ;  
     RETURN NEXT cur1;
    

     vbQueryText := '
          SELECT _tmpminPrice.minPrice
               '|| vbFieldNameText ||
        ' FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[(Movement_Data.minPrice)           -- AS PersonalId
                                                ] 
                                         ,  Movement_Data.UnitId AS UnitId
                                        , ARRAY[(Movement_Data.MarginPercent)           -- AS PersonalId
                                                ]
                                    FROM _tmpData AS Movement_Data
                                  ''
, ''SELECT _tmpUnitList.inUnitId FROM _tmpUnitList order by _tmpUnitList.NumUnit
                                                                  '') AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN _tmpminPrice ON _tmpminPrice.minPrice = D.Key[1]
                
        '

/*'
          SELECT _tmpminPrice.minPrice
               '|| vbFieldNameText ||
        ' FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[COALESCE (Movement_Data.minPrice, Object_Data.minPrice)           -- AS PersonalId
                                                ] :: Integer[]
                                         , COALESCE (Movement_Data.UnitId, Object_Data.UnitId) AS UnitId
                                         , ARRAY[ COALESCE(Movement_Data.MarginPercent, 0)
                                               , COALESCE (Movement_Data.MarginCategoryItemId, 0)
                                               , COALESCE (Movement_Data.MarginCategoryId,0) 
                                                ] :: TVarChar
                                    FROM _tmpData AS Movement_Data
                                        FULL JOIN  
                                         (SELECT _tmpUnitList.UnitId,_tmpminPrice.minPrice
                                          FROM _tmpUnitList, _tmpminPrice 
                                         ) AS Object_Data
                                           ON Object_Data.UnitId = Movement_Data.UnitId
                                          AND Object_Data.minPrice = Movement_Data.minPrice
                                         
                              '

                                , ''SELECT _tmpUnitList.inUnitId FROM _tmpUnitList order by _tmpUnitList.NumUnit
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN _tmpminPrice ON _tmpminPrice.minPrice = D.Key[1]
                
        '*/;


     OPEN cur2 FOR EXECUTE vbQueryText;  
     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MarginCategory_Cross (TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.17         * 
*/

-- тест
-- SELECT * FROM gpSelect_MarginCategory_Cross(now(), 0, FALSE, '');

/*



*/
