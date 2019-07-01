-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Unit(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inisShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Address TVarChar, Phone TVarChar
             , ProvinceCityId Integer, ProvinceCityName TVarChar
             , ParentId Integer, ParentName TVarChar
             , UserManagerId Integer, UserManagerName TVarChar, MemberName TVarChar
             , EMail_Member TVarChar, Phone_Member TVarChar
             , JuridicalName TVarChar, MarginCategoryName TVarChar, isLeaf boolean, isErased boolean
             , RouteId integer, RouteName TVarChar
             , RouteSortingId integer, RouteSortingName TVarChar
             , AreaId Integer, AreaName TVarChar
             , UnitRePriceId Integer, UnitRePriceName TVarChar
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , TaxService TFloat, TaxServiceNigth TFloat
             , StartServiceNigth TDateTime, EndServiceNigth TDateTime
             , CreateDate TDateTime, CloseDate TDateTime
             , TaxUnitStartDate TDateTime, TaxUnitEndDate TDateTime
             , isRepriceAuto Boolean
             , isOver Boolean
             , isUploadBadm Boolean
             , isMarginCategory Boolean
             , isReport Boolean
             , isGoodsCategory Boolean
             , Num_byReportBadm Integer
             , DateSP      TDateTime
             , StartTimeSP TDateTime
             , EndTimeSP   TDateTime
             , isSP        Boolean
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
    WITH 
    tmpByBadm AS (SELECT ObjectBoolean_UploadBadm.ObjectId    AS UnitId
                       , ROW_NUMBER() OVER (ORDER BY ObjectBoolean_UploadBadm.ObjectId )  ::integer  AS Num_byReportBadm
                  FROM ObjectBoolean AS ObjectBoolean_UploadBadm
                  WHERE ObjectBoolean_UploadBadm.DescId = zc_ObjectBoolean_Unit_UploadBadm()
                    AND ObjectBoolean_UploadBadm.ValueData = TRUE)

    SELECT 
        Object_Unit.Id                                       AS Id
      , Object_Unit.ObjectCode                               AS Code
      , Object_Unit.ValueData                                AS Name
      , ObjectString_Unit_Address.ValueData                  AS Address
      , ObjectString_Unit_Phone.ValueData                    AS Phone

      , Object_ProvinceCity.Id                               AS ProvinceCityId
      , Object_ProvinceCity.ValueData                        AS ProvinceCityName
                                                            
      , COALESCE(ObjectLink_Unit_Parent.ChildObjectId,0)     AS ParentId
      , Object_Parent.ValueData                              AS ParentName
                                                            
      , COALESCE (Object_UserManager.Id, 0)                  AS UserManagerId
      , Object_UserManager.ValueData                         AS UserManagerName
      , Object_Member.ValueData                              AS MemberName
      , ObjectString_EMail.ValueData                         AS EMail_Member
      , ObjectString_Phone.ValueData                         AS Phone_Member
                                                            
      , Object_Juridical.ValueData                           AS JuridicalName
      , Object_MarginCategory.ValueData                      AS MarginCategoryName
      , ObjectBoolean_isLeaf.ValueData                       AS isLeaf
      , Object_Unit.isErased                                 AS isErased
                                                            
      , 0                                                    AS RouteId
      , ''::TVarChar                                         AS RouteName
      , 0                                                    AS RouteSortingId
      , ''::TVarChar                                         AS RouteSortingName

      , Object_Area.Id                                       AS AreaId
      , Object_Area.ValueData                                AS AreaName
      
      , COALESCE (Object_UnitRePrice.Id,0)          ::Integer  AS UnitRePriceId
      , COALESCE (Object_UnitRePrice.ValueData, '') ::TVarChar AS UnitRePriceName

      , COALESCE (Object_PartnerMedical.Id,0)          ::Integer  AS PartnerMedicalId
      , COALESCE (Object_PartnerMedical.ValueData, '') ::TVarChar AS PartnerMedicalName
                 
      , ObjectFloat_TaxService.ValueData                     AS TaxService
      , ObjectFloat_TaxServiceNigth.ValueData                AS TaxServiceNigth

      , ObjectDate_StartServiceNigth.ValueData               AS StartServiceNigth
      , ObjectDate_EndServiceNigth.ValueData                 AS EndServiceNigth

      , COALESCE (ObjectDate_Create.ValueData, NULL)  :: TDateTime  AS CreateDate
      , COALESCE (ObjectDate_Close.ValueData, NULL)   :: TDateTime  AS CloseDate
      , COALESCE (ObjectDate_TaxUnitStart.ValueData, NULL)   :: TDateTime AS TaxUnitStartDate
      , COALESCE (ObjectDate_TaxUnitEnd.ValueData, NULL)     :: TDateTime AS TaxUnitEndDate
      
      , COALESCE(ObjectBoolean_RepriceAuto.ValueData, FALSE) AS isRepriceAuto
      , COALESCE(ObjectBoolean_Over.ValueData, FALSE)        AS isOver
      , COALESCE(ObjectBoolean_UploadBadm.ValueData, FALSE)  AS isUploadBadm
      , COALESCE(ObjectBoolean_MarginCategory.ValueData, FALSE)  AS isMarginCategory
      , COALESCE(ObjectBoolean_Report.ValueData, FALSE)          AS isReport
      , COALESCE(ObjectBoolean_GoodsCategory.ValueData, FALSE)   AS isGoodsCategory
      , COALESCE(tmpByBadm.Num_byReportBadm, Null) ::Integer     AS Num_byReportBadm
      
      , ObjectDate_SP.ValueData                       :: TDateTime AS DateSP
      , ObjectDate_StartSP.ValueData                  :: TDateTime AS StartTimeSP
      , ObjectDate_EndSP.ValueData                    :: TDateTime AS EndTimeSP
      , COALESCE (ObjectBoolean_SP.ValueData, FALSE)  :: Boolean   AS isSP
      

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
        
        LEFT JOIN ObjectString AS ObjectString_EMail
                               ON ObjectString_EMail.ObjectId = Object_Member.Id 
                              AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()
        LEFT JOIN ObjectString AS ObjectString_Phone
                               ON ObjectString_Phone.ObjectId = Object_Member.Id 
                              AND ObjectString_Phone.DescId = zc_ObjectString_Member_Phone()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                             ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

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

        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsCategory 
                                ON ObjectBoolean_GoodsCategory.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_GoodsCategory.DescId = zc_ObjectBoolean_Unit_GoodsCategory()

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

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RepriceAuto
                                ON ObjectBoolean_RepriceAuto.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_RepriceAuto.DescId = zc_ObjectBoolean_Unit_RepriceAuto()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Over
                                ON ObjectBoolean_Over.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_Over.DescId = zc_ObjectBoolean_Unit_Over()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_UploadBadm
                                ON ObjectBoolean_UploadBadm.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_UploadBadm.DescId = zc_ObjectBoolean_Unit_UploadBadm()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_MarginCategory
                                ON ObjectBoolean_MarginCategory.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_MarginCategory.DescId = zc_ObjectBoolean_Unit_MarginCategory()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Report
                                ON ObjectBoolean_Report.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                               
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

        LEFT JOIN tmpByBadm ON tmpByBadm.UnitId = Object_Unit.Id

    WHERE Object_Unit.DescId = zc_Object_Unit()
      AND (inisShowAll = True OR Object_Unit.isErased = False);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.19         *
 20.03.19         *
 15.01.19         * 
 22.10.18         *
 29.08.18         * Phone
 15.09.17         * add inisShowAll
 09.08.17         * add isReport
 08.08.17         * add ProvinceCity
 06.03.17         * add Address
 31.01.17         * add isMarginCategory
 16.01.17         * add isUploadBadm
 13.10.16         * add isOver
 08.04.16         *
 24.02.16         * add RepriceAuto
 21.08.14                         *
 27.06.14         *
 25.06.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit (False, '2')