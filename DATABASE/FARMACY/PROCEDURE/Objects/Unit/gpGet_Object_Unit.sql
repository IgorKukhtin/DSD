-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               Address TVarChar, Phone TVarChar,
               ProvinceCityId Integer, ProvinceCityName TVarChar,
               ParentId Integer, ParentName TVarChar,
               UserManagerId Integer, UserManagerName TVarChar,
               UserManager2Id Integer, UserManager2Name TVarChar,
               UserManager3Id Integer, UserManager3Name TVarChar,
               JuridicalId Integer, JuridicalName TVarChar, 
               MarginCategoryId Integer, MarginCategoryName TVarChar,
               AreaId Integer, AreaName TVarChar,
               UnitCategoryId Integer, UnitCategoryName TVarChar,
               UnitRePriceId Integer, UnitRePriceName TVarChar,
               PartnerMedicalId Integer, PartnerMedicalName TVarChar,
               isLeaf boolean, 
               TaxService TFloat, TaxServiceNigth TFloat,
               KoeffInSUN TFloat, KoeffOutSUN TFloat,
               StartServiceNigth TDateTime, EndServiceNigth TDateTime,
               CreateDate TDateTime, CloseDate TDateTime,
               TaxUnitStartDate TDateTime, TaxUnitEndDate TDateTime,
               isRepriceAuto Boolean,
               NormOfManDays Integer,
               PharmacyItem Boolean,
               isGoodsCategory Boolean,
               isSUN Boolean,
               DateSP      TDateTime,
               StartTimeSP TDateTime,
               EndTimeSP   TDateTime,
               isSP        Boolean,
               DividePartionDate Boolean,
               RedeemByHandSP Boolean,
               UnitOverdueId  Integer, UnitOverdueName TVarChar,
               isAutoMCS Boolean
               ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Unit());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_Unit()) AS Code
           , CAST ('' as TVarChar) AS Name
           , CAST ('' as TVarChar) AS Address
           , CAST ('' as TVarChar) AS Phone
           
           , CAST (0 as Integer)   AS ProvinceCityId
           , CAST ('' as TVarChar) AS ProvinceCityName
           
           , CAST (0 as Integer)   AS ParentId
           , CAST ('' as TVarChar) AS ParentName 
           
           , CAST (0 as Integer)   AS UserManagerId
           , CAST ('' as TVarChar) AS UserManagerName

           , CAST (0 as Integer)   AS UserManager2Id
           , CAST ('' as TVarChar) AS UserManager2Name

           , CAST (0 as Integer)   AS UserManager3Id
           , CAST ('' as TVarChar) AS UserManager3Name

           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName
           
           , CAST (0 as Integer)   AS MarginCategoryId
           , CAST ('' as TVarChar) AS MarginCategoryName

           , CAST (0 as Integer)   AS AreaId
           , CAST ('' as TVarChar) AS AreaName
           
           , CAST (0 as Integer)   AS UnitCategoryId
           , CAST ('' as TVarChar) AS UnitCategoryName

           , CAST (0 as Integer)   AS UnitRePriceId
           , CAST ('' as TVarChar) AS UnitRePriceName

           , CAST (0 as Integer)   AS PartnerMedicalId
           , CAST ('' as TVarChar) AS PartnerMedicalName

           , false                 AS isLeaf
           , CAST (0 as TFloat)    AS TaxService
           , CAST (0 as TFloat)    AS TaxServiceNigth

           , CAST (0 as TFloat)    AS KoeffInSUN
           , CAST (0 as TFloat)    AS KoeffOutSUN

           , CAST (Null as TDateTime) AS StartServiceNigth
           , CAST (Null as TDateTime) AS EndServiceNigth

           , CAST ((CURRENT_DATE + INTERVAL '1 DAY') as TDateTime) AS CreateDate
           , CAST ((CURRENT_DATE + INTERVAL '1 DAY') as TDateTime) AS CloseDate
           , CAST (Null as TDateTime) AS TaxUnitStartDate
           , CAST (Null as TDateTime) AS TaxUnitEndDate

           , False                 AS isRepriceAuto
           , CAST (0 as Integer)   AS NormOfManDays
           , False                 AS PharmacyItem
           , False                 AS isGoodsCategory
           , FALSE                 AS isSUN

           , CAST (Null as TDateTime) AS DateSP
           , CAST (Null as TDateTime) AS StartTimeSP
           , CAST (Null as TDateTime) AS EndTimeSP
           , FALSE                    AS isSP
           , FALSE                    AS DividePartionDate
           , FALSE                    AS RedeemByHandSP
           
           , CAST (0 as Integer)   AS UnitOverdueId
           , CAST ('' as TVarChar) AS UnitOverdueName
           , FALSE                 AS isAutoMCS
           
;
   ELSE
       RETURN QUERY 
      
    SELECT 
        Object_Unit.Id                                     AS Id
      , Object_Unit.ObjectCode                             AS Code
      , Object_Unit.ValueData                              AS Name
      , ObjectString_Unit_Address.ValueData                AS Address
      , ObjectString_Unit_Phone.ValueData                  AS Phone

      , Object_ProvinceCity.Id                             AS ProvinceCityId
      , Object_ProvinceCity.ValueData                      AS ProvinceCityName
      
      , Object_Parent.Id                                   AS ParentId
      , Object_Parent.ValueData                            AS ParentName

      , COALESCE (Object_UserManager.Id, 0)                AS UserManagerId
      , COALESCE (Object_Member.ValueData, Object_UserManager.ValueData) AS UserManagerName

      , COALESCE (Object_UserManager2.Id, 0)                AS UserManager2Id
      , COALESCE (Object_Member2.ValueData, Object_UserManager2.ValueData) AS UserManager2Name

      , COALESCE (Object_UserManager3.Id, 0)                AS UserManager3Id
      , COALESCE (Object_Member3.ValueData, Object_UserManager3.ValueData) AS UserManager3Name
      
      , Object_Juridical.Id                                AS JuridicalId
      , Object_Juridical.ValueData                         AS JuridicalName

      , Object_MarginCategory.Id                           AS MarginCategoryId
      , Object_MarginCategory.ValueData                    AS MarginCategoryName
      
      , Object_Area.Id                                     AS AreaId
      , Object_Area.ValueData                              AS AreaName
      
      , Object_UnitCategory.Id                             AS UnitCategoryId
      , Object_UnitCategory.ValueData                      AS UnitCategoryName

      , COALESCE (Object_UnitRePrice.Id,0)          ::Integer  AS UnitRePriceId
      , COALESCE (Object_UnitRePrice.ValueData, '') ::TVarChar AS UnitRePriceName

      , COALESCE (Object_PartnerMedical.Id,0)          ::Integer  AS PartnerMedicalId
      , COALESCE (Object_PartnerMedical.ValueData, '') ::TVarChar AS PartnerMedicalName

      , ObjectBoolean_isLeaf.ValueData                     AS isLeaf

      , ObjectFloat_TaxService.ValueData                   AS TaxService
      , ObjectFloat_TaxServiceNigth.ValueData              AS TaxServiceNigth

      , COALESCE (ObjectFloat_KoeffInSUN.ValueData,0)  ::TFloat AS KoeffInSUN
      , COALESCE (ObjectFloat_KoeffOutSUN.ValueData,0) ::TFloat AS KoeffOutSUN

      , CASE WHEN COALESCE(ObjectDate_StartServiceNigth.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_StartServiceNigth.ValueData ELSE Null END ::TDateTime  AS StartServiceNigth
      , CASE WHEN COALESCE(ObjectDate_EndServiceNigth.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_EndServiceNigth.ValueData ELSE Null END ::TDateTime  AS EndServiceNigth
      --, ObjectDate_EndServiceNigth.ValueData                 AS EndServiceNigth

      , COALESCE (ObjectDate_Create.ValueData, (CURRENT_DATE + INTERVAL '1 DAY')) ::TDateTime  AS CreateDate
      , COALESCE (ObjectDate_Close.ValueData, (CURRENT_DATE + INTERVAL '1 DAY'))  ::TDateTime  AS CloseDate

      , CASE WHEN COALESCE(ObjectDate_TaxUnitStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_TaxUnitStart.ValueData ELSE Null END ::TDateTime  AS TaxUnitStartDate
      , CASE WHEN COALESCE(ObjectDate_TaxUnitEnd.ValueData ::Time,'00:00')   <> '00:00' THEN ObjectDate_TaxUnitEnd.ValueData   ELSE Null END ::TDateTime  AS TaxUnitEndDate

      , COALESCE(ObjectBoolean_RepriceAuto.ValueData, False)     AS isRepriceAuto
      , ObjectFloat_NormOfManDays.ValueData::Integer             AS NormOfManDays
      , COALESCE(ObjectBoolean_PharmacyItem.ValueData, False)    AS PharmacyItem
      , COALESCE(ObjectBoolean_GoodsCategory.ValueData, FALSE)   AS isGoodsCategory
      , COALESCE(ObjectBoolean_SUN.ValueData, FALSE)             AS isSUN

      , ObjectDate_SP.ValueData                       :: TDateTime AS DateSP
      , CASE WHEN COALESCE (ObjectDate_StartSP.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_StartSP.ValueData ELSE Null END :: TDateTime AS StartTimeSP
      , CASE WHEN COALESCE (ObjectDate_EndSP.ValueData ::Time,'00:00')   <> '00:00' THEN ObjectDate_EndSP.ValueData ELSE Null END   :: TDateTime AS EndTimeSP
      , COALESCE (ObjectBoolean_SP.ValueData, FALSE)  :: Boolean   AS isSP
      , COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)  :: Boolean   AS DividePartionDate
      , COALESCE (ObjectBoolean_RedeemByHandSP.ValueData, FALSE)  :: Boolean   AS RedeemByHandSP
      
      , COALESCE (Object_UnitOverdue.Id,0)          ::Integer  AS UnitOverdueId
      , COALESCE (Object_UnitOverdue.ValueData, '') ::TVarChar AS UnitOverdueName
      , COALESCE (ObjectBoolean_Unit_AutoMCS.ValueData, FALSE):: Boolean AS isAutoMCS
      
    FROM Object AS Object_Unit
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
      
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
         
        LEFT JOIN ObjectLink AS ObjectLink_Unit_MarginCategory
                             ON ObjectLink_Unit_MarginCategory.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_MarginCategory.DescId = zc_ObjectLink_Unit_MarginCategory()
        LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = ObjectLink_Unit_MarginCategory.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                             ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
        LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Unit_UserManager
                             ON ObjectLink_Unit_UserManager.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_UserManager.DescId = zc_ObjectLink_Unit_UserManager()
        LEFT JOIN Object AS Object_UserManager ON Object_UserManager.Id = ObjectLink_Unit_UserManager.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_UserManager.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_UserManager2
                             ON ObjectLink_Unit_UserManager2.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_UserManager2.DescId = zc_ObjectLink_Unit_UserManager2()
        LEFT JOIN Object AS Object_UserManager2 ON Object_UserManager2.Id = ObjectLink_Unit_UserManager2.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member2
                             ON ObjectLink_User_Member2.ObjectId = Object_UserManager2.Id
                            AND ObjectLink_User_Member2.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = ObjectLink_User_Member2.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_UserManager3
                             ON ObjectLink_Unit_UserManager3.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_UserManager3.DescId = zc_ObjectLink_Unit_UserManager3()
        LEFT JOIN Object AS Object_UserManager3 ON Object_UserManager3.Id = ObjectLink_Unit_UserManager3.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member3
                             ON ObjectLink_User_Member3.ObjectId = Object_UserManager3.Id
                            AND ObjectLink_User_Member3.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = ObjectLink_User_Member3.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                             ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId
                
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                             ON ObjectLink_Unit_Category.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()
        LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_UnitRePrice
                             ON ObjectLink_Unit_UnitRePrice.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_UnitRePrice.DescId = zc_ObjectLink_Unit_UnitRePrice()
        LEFT JOIN Object AS Object_UnitRePrice ON Object_UnitRePrice.Id = ObjectLink_Unit_UnitRePrice.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_PartnerMedical
                             ON ObjectLink_Unit_PartnerMedical.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
        LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_Unit_PartnerMedical.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SP 
                                ON ObjectBoolean_SP.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SP.DescId = zc_ObjectBoolean_Unit_SP()

        LEFT JOIN ObjectString AS ObjectString_Unit_Address
                               ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                              AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

        LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                               ON ObjectString_Unit_Phone.ObjectId = Object_Unit.Id
                              AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxService
                              ON ObjectFloat_TaxService.ObjectId = Object_Unit.Id
                             AND ObjectFloat_TaxService.DescId = zc_ObjectFloat_Unit_TaxService()

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxServiceNigth
                              ON ObjectFloat_TaxServiceNigth.ObjectId = Object_Unit.Id
                             AND ObjectFloat_TaxServiceNigth.DescId = zc_ObjectFloat_Unit_TaxServiceNigth()

        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffInSUN
                              ON ObjectFloat_KoeffInSUN.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffInSUN.DescId = zc_ObjectFloat_Unit_KoeffInSUN()
        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffOutSUN
                              ON ObjectFloat_KoeffOutSUN.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffOutSUN.DescId = zc_ObjectFloat_Unit_KoeffOutSUN()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RepriceAuto
                                ON ObjectBoolean_RepriceAuto.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_RepriceAuto.DescId = zc_ObjectBoolean_Unit_RepriceAuto()

        LEFT JOIN ObjectDate AS ObjectDate_StartServiceNigth
                             ON ObjectDate_StartServiceNigth.ObjectId = Object_Unit.Id
                            AND ObjectDate_StartServiceNigth.DescId = zc_ObjectDate_Unit_StartServiceNigth()

        LEFT JOIN ObjectDate AS ObjectDate_EndServiceNigth
                             ON ObjectDate_EndServiceNigth.ObjectId = Object_Unit.Id
                            AND ObjectDate_EndServiceNigth.DescId = zc_ObjectDate_Unit_EndServiceNigth()

        LEFT JOIN ObjectDate AS ObjectDate_Create
                             ON ObjectDate_Create.ObjectId = Object_Unit.Id
                            AND ObjectDate_Create.DescId = zc_ObjectDate_Unit_Create()
        LEFT JOIN ObjectDate AS ObjectDate_Close
                             ON ObjectDate_Close.ObjectId = Object_Unit.Id
                            AND ObjectDate_Close.DescId = zc_ObjectDate_Unit_Close()

        LEFT JOIN ObjectFloat AS ObjectFloat_NormOfManDays 
                              ON ObjectFloat_NormOfManDays.ObjectId = Object_Unit.Id
                             AND ObjectFloat_NormOfManDays.DescId = zc_ObjectFloat_Unit_NormOfManDays()
                            
        LEFT JOIN ObjectBoolean AS ObjectBoolean_PharmacyItem
                                ON ObjectBoolean_PharmacyItem.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_PharmacyItem.DescId = zc_ObjectBoolean_Unit_PharmacyItem()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsCategory 
                                ON ObjectBoolean_GoodsCategory.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_GoodsCategory.DescId = zc_ObjectBoolean_Unit_GoodsCategory()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN 
                                ON ObjectBoolean_SUN.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_SUN.DescId = zc_ObjectBoolean_Unit_SUN()

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitStart
                             ON ObjectDate_TaxUnitStart.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitStart.DescId = zc_ObjectDate_Unit_TaxUnitStart()

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitEnd
                             ON ObjectDate_TaxUnitEnd.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitEnd.DescId = zc_ObjectDate_Unit_TaxUnitEnd()

        LEFT JOIN ObjectDate AS ObjectDate_SP
                             ON ObjectDate_SP.ObjectId = Object_Unit.Id
                            AND ObjectDate_SP.DescId = zc_ObjectDate_Unit_SP()

        LEFT JOIN ObjectDate AS ObjectDate_StartSP
                             ON ObjectDate_StartSP.ObjectId = Object_Unit.Id
                            AND ObjectDate_StartSP.DescId = zc_ObjectDate_Unit_StartSP()

        LEFT JOIN ObjectDate AS ObjectDate_EndSP
                             ON ObjectDate_EndSP.ObjectId = Object_Unit.Id
                            AND ObjectDate_EndSP.DescId = zc_ObjectDate_Unit_EndSP()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RedeemByHandSP
                                ON ObjectBoolean_RedeemByHandSP.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_RedeemByHandSP.DescId = zc_ObjectBoolean_Unit_RedeemByHandSP()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_UnitOverdue
                             ON ObjectLink_Unit_UnitOverdue.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_UnitOverdue.DescId = zc_ObjectLink_Unit_UnitOverdue()
        LEFT JOIN Object AS Object_UnitOverdue ON Object_UnitOverdue.Id = ObjectLink_Unit_UnitOverdue.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Unit_AutoMCS
                                ON ObjectBoolean_Unit_AutoMCS.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_Unit_AutoMCS.DescId = zc_ObjectBoolean_Unit_AutoMCS()

    WHERE Object_Unit.Id = inId;

   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Unit (integer, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.08.19                                                        * AutoMCS
 11.07.19         *
 02.07.19                                                        * add UnitOverdue
 02.07.19         *
 14.06.19                                                        * add DividePartionDate
 09.02.19                                                        * add PharmacyItem
 15.01.19         *
 22.10.18         *
 29.08.18         * Phone
 14.05.18                                                        * add NormOfManDays
 05.05.18                                                        * add UnitCategory
 08.08.17         * add ProvinceCity
 06.03.17         * add Address
 08.04.16         *
 24.02.16         * 
 27.06.14         *
 11.06.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Unit('2')

--select * from gpGet_Object_Unit(inId := 377613 ,  inSession := '3'::TVarChar);
