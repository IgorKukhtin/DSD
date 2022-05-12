-- Function: gpSelect_Object_OrderShedule()

DROP FUNCTION IF EXISTS gpSelect_Object_OrderShedule(Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderShedule(
    IN inUnitId      Integer,  -- Подразделение
    IN inJuridicalId Integer,  -- Юр. лицо
    IN inShowErased  Boolean,  -- показать удаленные да/нет
    IN inisShowAll   Boolean,  -- показать все связи
    IN inSession     TVarChar  -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer,
               Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, 
               Value5 TFloat, Value6 TFloat, Value7 TFloat,
               OurJuridicalName TVarChar,
               UnitId Integer, UnitName TVarChar, AreaName TVarChar,
               ProvinceCityId Integer, ProvinceCityName TVarChar,
               JuridicalName TVarChar,
               ContractId Integer, ContractName TVarChar,
               isErased_OrderShedule boolean, isErased_Contract boolean, isErased boolean, 
               Inf_Text1 TVarChar, Inf_Text2 TVarChar,
               Color_Calc1 Integer, Color_Calc2 Integer, Color_Calc3 Integer, Color_Calc4 Integer,
               Color_Calc5 Integer, Color_Calc6 Integer, Color_Calc7 Integer,
               OrderSumm TVarChar, OrderTime TVarChar, OrderSummComment TVarChar,
               UpdateUserName TVarChar, UpdateDate TDateTime
               ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OrderShedule());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Контролшь использования подразделения
   IF COALESCE (inUnitId, 0) <> 0
   THEN
      inUnitId := gpGet_CheckingUser_Unit(inUnitId, inSession);
   END IF;


   RETURN QUERY 
   WITH 
   tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId --
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        ),
   tmpObject AS (SELECT Object_OrderShedule.Id                           AS Id
                      , Object_OrderShedule.ObjectCode                   AS Code
                      , ObjectLink_OrderShedule_Unit.ChildObjectId       AS UnitId 
                      , ObjectLink_OrderShedule_Contract.ChildObjectId   AS ContractId
                      , ObjectLink_Contract_Juridical.ChildObjectId      AS JuridicalId
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1) ::TFloat AS Value1
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2) ::TFloat AS Value2
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3) ::TFloat AS Value3
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4) ::TFloat AS Value4
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5) ::TFloat AS Value5
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6) ::TFloat AS Value6
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7) ::TFloat AS Value7
        
                      , Object_OrderShedule.isErased     AS isErased
                 FROM Object AS Object_OrderShedule
                      INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                            ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                                           AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                                           AND (ObjectLink_OrderShedule_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
                      INNER JOIN tmpUnit ON tmpUnit.UnitId = ObjectLink_OrderShedule_Unit.ChildObjectId
                      LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                           ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                                          AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                      INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                             ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_OrderShedule_Contract.ChildObjectId
                                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                            AND (ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                 WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
                  AND (Object_OrderShedule.isErased = inShowErased OR inShowErased = True OR inisShowAll = True)
                 )
   , tmpAll AS (SELECT Object_Unit.Id           AS UnitId
                     , Object_Contract.Id       AS ContractId
                     , ObjectLink_Contract_Juridical.ChildObjectId  AS JuridicalId
                     , Object_Contract.isErased AS isErased_Contract
                FROM Object AS Object_Unit
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                          ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                         AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                     LEFT JOIN Object AS Object_Contract ON Object_Contract.DescId = zc_Object_Contract()
                     INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                            ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                           AND (ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                WHERE Object_Unit.DescId = zc_Object_Unit()
                  AND (Object_Unit.Id = inUnitId OR inUnitId = 0)
                  AND ObjectLink_Unit_Parent.ChildObjectId is not  NULL
                  AND inisShowAll = True
                )
   , tmpProtocolAll AS (SELECT tmpObject.Id
                             , ObjectProtocol.OperDate
                             , ObjectProtocol.UserId
                        FROM tmpObject
                         
                             INNER JOIN ObjectProtocol ON ObjectProtocol.ObjectId = tmpObject.Id
                        UNION ALL
                        SELECT tmpObject.Id
                             , ObjectProtocol_arc.OperDate
                             , ObjectProtocol_arc.UserId
                        FROM tmpObject
                         
                             INNER JOIN ObjectProtocol_arc ON ObjectProtocol_arc.ObjectId = tmpObject.Id
                        )
   , tmpProtocol AS (SELECT tmpProtocolAll.Id
                          , tmpProtocolAll.OperDate
                          , tmpProtocolAll.UserId
                          , ROW_NUMBER() OVER (PARTITION BY tmpProtocolAll.Id ORDER BY tmpProtocolAll.OperDate DESC) AS Ord
                     FROM tmpProtocolAll
                     )

       SELECT 
             Object_OrderShedule.Id
           , Object_OrderShedule.Code
       
           , Object_OrderShedule.Value1 
           , Object_OrderShedule.Value2 
           , Object_OrderShedule.Value3 
           , Object_OrderShedule.Value4 
           , Object_OrderShedule.Value5 
           , Object_OrderShedule.Value6 
           , Object_OrderShedule.Value7 

           , Object_Unit_Juridical.ValueData      AS OurJuridicalName
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , Object_Area.ValueData                AS AreaName
           
           , Object_ProvinceCity.Id               AS ProvinceCityId
           , Object_ProvinceCity.ValueData        AS ProvinceCityName
      
           , Object_Contract_Juridical.ValueData  AS JuridicalName
           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ValueData            AS ContractName 
                     
           , Object_OrderShedule.isErased         AS isErased_OrderShedule
           , Object_Contract.isErased             AS isErased_Contract
           , CASE WHEN Object_OrderShedule.isErased = TRUE OR Object_Contract.isErased = TRUE THEN TRUE ELSE FALSE END  :: Boolean AS isErased

           , (CASE WHEN Object_OrderShedule.Value1 in (1,3) THEN 'Понедельник,' ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value2 in (1,3) THEN 'Вторник,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value3 in (1,3) THEN 'Среда,'       ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value4 in (1,3) THEN 'Четверг,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value5 in (1,3) THEN 'Пятница,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value6 in (1,3) THEN 'Суббота,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value7 in (1,3) THEN 'Воскресенье'  ELSE '' END) ::TVarChar          AS Inf_Text1
           , (CASE WHEN Object_OrderShedule.Value1 in (2,3) THEN 'Понедельник,' ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value2 in (2,3) THEN 'Вторник,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value3 in (2,3) THEN 'Среда,'       ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value4 in (2,3) THEN 'Четверг,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value5 in (2,3) THEN 'Пятница,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value6 in (2,3) THEN 'Суббота,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value7 in (2,3) THEN 'Воскресенье'  ELSE '' END) ::TVarChar          AS Inf_Text2
           
           , CASE WHEN Object_OrderShedule.Value1 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value1 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value1 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc1
           , CASE WHEN Object_OrderShedule.Value2 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value2 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value2 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc2
           , CASE WHEN Object_OrderShedule.Value3 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value3 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value3 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc3
           , CASE WHEN Object_OrderShedule.Value4 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value4 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value4 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc4
           , CASE WHEN Object_OrderShedule.Value5 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value5 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value5 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc5
           , CASE WHEN Object_OrderShedule.Value6 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value6 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value6 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc6
           , CASE WHEN Object_OrderShedule.Value7 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value7 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value7 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc7

/*           , CASE WHEN COALESCE (ObjectFloat_OrderSumm_Contract.ValueData, 0) = 0 
                  THEN CASE WHEN COALESCE (ObjectFloat_OrderSumm.ValueData, 0) = 0 
                            THEN CASE WHEN COALESCE (ObjectString_OrderSumm_Contract.ValueData, '') <> '' 
                                      THEN ObjectString_OrderSumm_Contract.ValueData 
                                      ELSE COALESCE (ObjectString_OrderSumm.ValueData,'')
                                 END
                            ELSE CAST (ObjectFloat_OrderSumm.ValueData AS NUMERIC (16, 2)) ||' ' || COALESCE (ObjectString_OrderSumm.ValueData,'')
                       END
                  ELSE CAST (ObjectFloat_OrderSumm_Contract.ValueData AS NUMERIC (16, 2)) ||' ' || COALESCE (ObjectString_OrderSumm_Contract.ValueData,'')
             END                                            ::TVarChar AS OrderSumm

           , CASE WHEN COALESCE (ObjectString_OrderTime_Contract.ValueData,'')  <> ''  
                  THEN ObjectString_OrderTime_Contract.ValueData 
                  ELSE COALESCE (ObjectString_OrderTime.ValueData,'') 
             END ::TVarChar AS OrderTime
*/
           , CAST (ObjectFloat_OrderSumm_Contract.ValueData AS NUMERIC (16, 2)) ::TVarChar AS OrderSumm
           , COALESCE (ObjectString_OrderTime_Contract.ValueData,'')            ::TVarChar AS OrderTime
           , COALESCE (ObjectString_OrderSumm_Contract.ValueData,'')            ::TVarChar AS OrderSummComment
           
           , Object_User.ValueData        AS UpdateUserName
           , tmpProtocol.OperDate         AS UpdateDate

       FROM tmpObject AS Object_OrderShedule
           FULL JOIN tmpAll ON tmpAll.UnitId = Object_OrderShedule.UnitId
                           AND tmpAll.ContractId = Object_OrderShedule.ContractId  

           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = COALESCE (Object_OrderShedule.ContractId, tmpAll.ContractId)
           
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (Object_OrderShedule.UnitId, tmpAll.UnitId)

           LEFT JOIN Object AS Object_Contract_Juridical ON Object_Contract_Juridical.Id = COALESCE (Object_OrderShedule.JuridicalId, tmpAll.JuridicalId) 
          
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Unit_Juridical ON Object_Unit_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId       

           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
           LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id 
                               AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId
           
            --
/*           LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm
                                 ON ObjectFloat_OrderSumm.ObjectId = Object_Contract_Juridical.Id
                                AND ObjectFloat_OrderSumm.DescId = zc_ObjectFloat_Juridical_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderSumm
                                  ON ObjectString_OrderSumm.ObjectId = Object_Contract_Juridical.Id
                                 AND ObjectString_OrderSumm.DescId = zc_ObjectString_Juridical_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderTime
                                  ON ObjectString_OrderTime.ObjectId = Object_Contract_Juridical.Id
                                 AND ObjectString_OrderTime.DescId = zc_ObjectString_Juridical_OrderTime()
*/
           --
           LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm_Contract
                                 ON ObjectFloat_OrderSumm_Contract.ObjectId = Object_Contract.Id
                                AND ObjectFloat_OrderSumm_Contract.DescId = zc_ObjectFloat_Contract_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderSumm_Contract 
                                  ON ObjectString_OrderSumm_Contract.ObjectId = Object_Contract.Id
                                 AND ObjectString_OrderSumm_Contract.DescId = zc_ObjectString_Contract_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderTime_Contract
                                  ON ObjectString_OrderTime_Contract.ObjectId = Object_Contract.Id
                                 AND ObjectString_OrderTime_Contract.DescId = zc_ObjectString_Contract_OrderTime()
                                 
           LEFT JOIN tmpProtocol ON tmpProtocol.ID = Object_OrderShedule.Id
                                AND tmpProtocol.ord = 1
           LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId
 ;
  
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.08.18                                                        *
 22.02.18         *
 23.01.18         *
 08.08.17         *
 22.06.17         *
 14.01.17         *
 05.10.16         * parce
 20.09.14         *

*/

-- тест
--
select * from gpSelect_Object_OrderShedule(inUnitId := 0 , inJuridicalId := 0 , inShowErased := False , inisShowAll := False ,  inSession := '3');