-- Function: gpSelect_Scale_Personal()

-- DROP FUNCTION IF EXISTS gpSelect_Scale_Personal (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_Personal (Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Personal(
    IN inIsGoodsComplete Boolean  , -- склад ГП/производство/упаковка or обвалка
    IN inBranchCode      Integer  , --
    IN inSession         TVarChar   -- сессия пользователя
)
RETURNS TABLE (PersonalId     Integer
             , PersonalCode   Integer
             , PersonalName   TVarChar
             , PositionId     Integer
             , PositionCode   Integer
             , PositionName   TVarChar
             , UnitId         Integer
             , UnitCode       Integer
             , UnitName       TVarChar
             , IsErased       Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Scale_Personal());
   vbUserId:= lpGetUserBySession (inSession);


   IF inBranchCode BETWEEN 101 AND 110 AND inIsGoodsComplete = TRUE
   THEN
         -- Результат
         RETURN QUERY
            WITH tmpPersonal AS (SELECT View_Personal.PersonalId
                                      , View_Personal.PersonalCode
                                      , View_Personal.PersonalName
                                      , View_Personal.PositionId
                                      , View_Personal.PositionCode
                                      , View_Personal.PositionName
                                      , View_Personal.UnitId
                                      , View_Personal.UnitCode
                                      , View_Personal.UnitName
                                      , View_Personal.IsErased
                                        -- Вантажник
                                      , ROW_NUMBER() OVER (PARTITION BY View_Personal.PersonalCode ORDER BY CASE WHEN View_Personal.PositionId = 12939 THEN 1 ELSE 0 END, View_Personal.PersonalId) AS Ord
                                 FROM Object_Personal_View AS View_Personal
                                      LEFT JOIN ObjectLink AS ObjectLink_parent0 ON ObjectLink_parent0.ObjectId = View_Personal.UnitId AND ObjectLink_parent0.DescId = zc_ObjectLink_Unit_Parent()
                                      LEFT JOIN ObjectLink AS ObjectLink_parent1 ON ObjectLink_parent1.ObjectId = ObjectLink_parent0.ChildObjectId AND ObjectLink_parent1.DescId = zc_ObjectLink_Unit_Parent()
                                      LEFT JOIN ObjectLink AS ObjectLink_parent2 ON ObjectLink_parent2.ObjectId = ObjectLink_parent1.ChildObjectId AND ObjectLink_parent2.DescId = zc_ObjectLink_Unit_Parent()
                                      LEFT JOIN ObjectLink AS ObjectLink_parent3 ON ObjectLink_parent3.ObjectId = ObjectLink_parent2.ChildObjectId AND ObjectLink_parent3.DescId = zc_ObjectLink_Unit_Parent()
                                 WHERE View_Personal.IsErased = FALSE
                                   AND View_Personal.isDateOut = FALSE
                                   AND (ObjectLink_parent0.ObjectId      = 8433 -- Производство -- Участок мясного сырья
                                     OR ObjectLink_parent0.ChildObjectId = 8433 -- Производство -- Участок мясного сырья
                                     OR ObjectLink_parent1.ChildObjectId = 8433 -- Производство -- Участок мясного сырья
                                     OR ObjectLink_parent2.ChildObjectId = 8433 -- Производство -- Участок мясного сырья
                                     OR ObjectLink_parent3.ChildObjectId = 8433 -- Производство -- Участок мясного сырья
                                       )
                                )

            -- Результат
            SELECT tmpPersonal.PersonalId
                 , tmpPersonal.PersonalCode
                 , tmpPersonal.PersonalName
                 , tmpPersonal.PositionId
                 , tmpPersonal.PositionCode
                 , tmpPersonal.PositionName
                 , tmpPersonal.UnitId
                 , tmpPersonal.UnitCode
                 , tmpPersonal.UnitName
                 , tmpPersonal.IsErased
            FROM tmpPersonal
            WHERE tmpPersonal.Ord = 1
            ORDER BY tmpPersonal.PersonalName
                   , tmpPersonal.PositionName
           ;
   ELSE
        -- определяется уровень доступа
        vbBranchId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), 0);
        vbIsConstraint:= vbBranchId_Constraint > 0;

         -- Результат
         RETURN QUERY
            WITH tmpPersonal AS (SELECT View_Personal.PersonalId
                                      , View_Personal.PersonalCode
                                      , View_Personal.PersonalName
                                      , View_Personal.PositionId
                                      , View_Personal.PositionCode
                                      , View_Personal.PositionName
                                      , View_Personal.UnitId
                                      , View_Personal.UnitCode
                                      , View_Personal.UnitName
                                      , View_Personal.IsErased
                                        -- Вантажник
                                      , ROW_NUMBER() OVER (PARTITION BY View_Personal.PersonalCode ORDER BY CASE WHEN View_Personal.PositionId = 12939 THEN 1 ELSE 0 END, View_Personal.PersonalId) AS Ord
                                 FROM Object_Personal_View AS View_Personal
                                 WHERE View_Personal.IsErased = FALSE
                                   AND View_Personal.isDateOut = FALSE
                                   AND ((vbIsConstraint = FALSE
                                     AND View_Personal.UnitId IN (8459 -- Склад Реализации
                                                                , 8461 -- Склад Возвратов
                                                                 )
                                     AND View_Personal.PositionId IN (12970 -- кладовщик
                                                                    , 12964 -- кладовщик Киев
                                                                    , 12981 -- кладовщик возвратов
                                                                    , 12971 -- кладовщик ночь
                                                                    , 18315 -- комплектовщик
                                                                    , 12943 -- нач. отдела комплектации
                                                                    , 12988 -- стикеровщики
                                                                    , 12939 -- грузчик экспедиции
                                                                    -- , 12982 -- старший кладовщик
                                                                    , 12988 -- стикеровщик
                                                                     )
                                        )
                                     OR (View_Personal.BranchId = vbBranchId_Constraint
                                     AND vbIsConstraint = TRUE)
                                     OR (View_Personal.PositionId IN (8466  -- водитель
                                                                    , 81178 -- экспедитор
                                                                    , 12988 -- стикеровщик
                                                                     )
                                       ))
                                )

            -- Результат
            SELECT tmpPersonal.PersonalId
                 , tmpPersonal.PersonalCode
                 , tmpPersonal.PersonalName
                 , tmpPersonal.PositionId
                 , tmpPersonal.PositionCode
                 , tmpPersonal.PositionName
                 , tmpPersonal.UnitId
                 , tmpPersonal.UnitCode
                 , tmpPersonal.UnitName
                 , tmpPersonal.IsErased
            FROM tmpPersonal
            WHERE tmpPersonal.Ord = 1
            ORDER BY tmpPersonal.PersonalName
                   , tmpPersonal.PositionName
           ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.05.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Personal (FALSE, 201, zfCalc_UserAdmin())
