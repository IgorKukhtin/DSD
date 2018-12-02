-- Покупатели  Function: gpSelect_Object_Client (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Client (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Client (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Client(
    IN inUnitId      Integer,       -- подразделение
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DiscountCard TVarChar, DiscountTax TFloat, DiscountTaxTwo TFloat
             , TotalCount TFloat, TotalSumm TFloat, TotalSummDiscount TFloat, TotalSummPay TFloat
             , LastCount TFloat, LastSumm TFloat, LastSummDiscount TFloat
             , TotalDebtSumm TFloat, TotalDebtSumm_All TFloat
             , LastDate TDateTime
             , Address TVarChar, HappyDate TDateTime, PhoneMobile TVarChar, Phone TVarChar
             , Mail TVarChar, Comment TVarChar, CityName TVarChar
             , DiscountKindName TVarChar
             , LastUserName TVarChar, UnitName_User TVarChar
             , UnitName_insert TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isOutlet Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbIsOperPrice Boolean;
   DECLARE vbIsOutlet    Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Client());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка может ли смотреть любой магазин, или только свой
     PERFORM lpCheckUnit_byUser (inUnitId_by:= inUnitId, inUserId:= vbUserId);


     -- Получили - показывать ЛИ цену ВХ.
     vbIsOperPrice:= lpCheckOperPrice_visible (vbUserId);
     
     -- Получили - показывать ЛИ 
     vbIsOutlet := EXISTS (SELECT 1 FROM lfSelect_Object_Unit_isOutlet() AS lfSelect WHERE lfSelect.UnitId = inUnitId);


     -- Результат
     RETURN QUERY
     WITH
     tmpUnit_isOutlet AS (SELECT * FROM lfSelect_Object_Unit_isOutlet())
   , tmpContainer AS (SELECT CLO_Client.ObjectId                  AS ClientId
                           , SUM (COALESCE (Container.Amount, 0)) AS Summa_All
                           , SUM (CASE WHEN COALESCE (inUnitId, 0) <> 0 AND Container.WhereObjectId = inUnitId THEN COALESCE (Container.Amount, 0) ELSE 0 END) AS Summa
                      FROM Container
                           INNER JOIN ContainerLinkObject AS CLO_Client
                                                          ON CLO_Client.ContainerId = Container.Id
                                                         AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                      WHERE Container.ObjectId <> zc_Enum_Account_20102()
                        AND Container.DescId = zc_Container_Summ()
                      GROUP BY CLO_Client.ObjectId
                      HAVING SUM (COALESCE (Container.Amount, 0)) <> 0
                          OR SUM (CASE WHEN COALESCE (inUnitId, 0) <> 0 AND Container.WhereObjectId = inUnitId THEN COALESCE (Container.Amount, 0) ELSE 0 END) <> 0
                     )
       SELECT
             Object_Client.Id                        AS Id
           , Object_Client.ObjectCode                AS Code
           , Object_Client.ValueData                 AS Name
           , ObjectString_DiscountCard.ValueData     AS DiscountCard
           , ObjectFloat_DiscountTax.ValueData       AS DiscountTax
           , ObjectFloat_DiscountTaxTwo.ValueData    AS DiscountTaxTwo
           , ObjectFloat_TotalCount.ValueData        AS TotalCount
           , CASE WHEN vbIsOperPrice = TRUE THEN ObjectFloat_TotalSumm.ValueData         ELSE 0 END :: TFloat AS TotalSumm
           , CASE WHEN vbIsOperPrice = TRUE THEN ObjectFloat_TotalSummDiscount.ValueData ELSE 0 END :: TFloat AS TotalSummDiscount
           , CASE WHEN vbIsOperPrice = TRUE THEN ObjectFloat_TotalSummPay.ValueData      ELSE 0 END :: TFloat AS TotalSummPay
           , ObjectFloat_LastCount.ValueData         AS LastCount
           , ObjectFloat_LastSumm.ValueData          AS LastSumm
           , ObjectFloat_LastSummDiscount.ValueData  AS LastSummDiscount
           , tmpContainer.Summa         ::TFloat     AS TotalDebtSumm
           , tmpContainer.Summa_All     ::TFloat     AS TotalDebtSumm_All
           , ObjectDate_LastDate.ValueData           AS LastDate
           , ObjectString_Address.ValueData          AS Address
           , ObjectDate_HappyDate.ValueData          AS HappyDate
           , ObjectString_PhoneMobile.ValueData      AS PhoneMobile
           , ObjectString_Phone.ValueData            AS Phone
           , ObjectString_Mail.ValueData             AS Mail
           , ObjectString_Comment.ValueData          AS Comment
           , Object_City.ValueData                   AS CityName
           , Object_DiscountKind.ValueData           AS DiscountKindName
           , Object_LastUser.ValueData               AS LastUserName
           , Object_Unit.ValueData                   AS UnitName_User

           , Object_Unit_Insert.ValueData            AS UnitName_insert
           , Object_User_Insert.ValueData            AS InsertName
           , ObjectDate_Protocol_Insert.ValueData    AS InsertDate

           , COALESCE (ObjectBoolean_Client_Outlet.ValueData, FALSE) :: Boolean AS isOutlet

           , Object_Client.isErased                  AS isErased

       FROM Object AS Object_Client

            LEFT JOIN ObjectLink AS ObjectLink_Client_City
                                 ON ObjectLink_Client_City.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_City.DescId = zc_ObjectLink_Client_City()
            LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Client_City.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Client_DiscountKind
                                 ON ObjectLink_Client_DiscountKind.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_DiscountKind.DescId = zc_ObjectLink_Client_DiscountKind()
            LEFT JOIN Object AS Object_DiscountKind ON Object_DiscountKind.Id = ObjectLink_Client_DiscountKind.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_DiscountCard
                                   ON ObjectString_DiscountCard.ObjectId = Object_Client.Id
                                  AND ObjectString_DiscountCard.DescId = zc_ObjectString_Client_DiscountCard()

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                  ON ObjectFloat_DiscountTax.ObjectId = Object_Client.Id
                                 AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTaxTwo
                                  ON ObjectFloat_DiscountTaxTwo.ObjectId = Object_Client.Id
                                 AND ObjectFloat_DiscountTaxTwo.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()

            LEFT JOIN ObjectFloat AS ObjectFloat_TotalCount
                                  ON ObjectFloat_TotalCount.ObjectId = Object_Client.Id
                                 AND ObjectFloat_TotalCount.DescId = zc_ObjectFloat_Client_TotalCount()

            LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                                  ON ObjectFloat_TotalSumm.ObjectId = Object_Client.Id
                                 AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_Client_TotalSumm()

            LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummDiscount
                                  ON ObjectFloat_TotalSummDiscount.ObjectId = Object_Client.Id
                                 AND ObjectFloat_TotalSummDiscount.DescId = zc_ObjectFloat_Client_TotalSummDiscount()

            LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummPay
                                  ON ObjectFloat_TotalSummPay.ObjectId = Object_Client.Id
                                 AND ObjectFloat_TotalSummPay.DescId = zc_ObjectFloat_Client_TotalSummPay()

            LEFT JOIN ObjectFloat AS ObjectFloat_LastCount
                                  ON ObjectFloat_LastCount.ObjectId = Object_Client.Id
                                 AND ObjectFloat_LastCount.DescId = zc_ObjectFloat_Client_LastCount()

            LEFT JOIN ObjectFloat AS ObjectFloat_LastSumm
                                  ON ObjectFloat_LastSumm.ObjectId = Object_Client.Id
                                 AND ObjectFloat_LastSumm.DescId = zc_ObjectFloat_Client_LastSumm()

            LEFT JOIN ObjectFloat AS ObjectFloat_LastSummDiscount
                                  ON ObjectFloat_LastSummDiscount.ObjectId = Object_Client.Id
                                 AND ObjectFloat_LastSummDiscount.DescId = zc_ObjectFloat_Client_LastSummDiscount()

            LEFT JOIN ObjectDate AS  ObjectDate_LastDate
                                  ON ObjectDate_LastDate.ObjectId = Object_Client.Id
                                 AND ObjectDate_LastDate.DescId = zc_ObjectDate_Client_LastDate()

            LEFT JOIN ObjectString AS  ObjectString_Address
                                   ON  ObjectString_Address.ObjectId = Object_Client.Id
                                  AND  ObjectString_Address.DescId = zc_ObjectString_Client_Address()

            LEFT JOIN ObjectDate AS  ObjectDate_HappyDate
                                  ON ObjectDate_HappyDate.ObjectId = Object_Client.Id
                                 AND ObjectDate_HappyDate.DescId = zc_ObjectDate_Client_HappyDate()

            LEFT JOIN ObjectString AS  ObjectString_PhoneMobile
                                   ON  ObjectString_PhoneMobile.ObjectId = Object_Client.Id
                                  AND  ObjectString_PhoneMobile.DescId = zc_ObjectString_Client_PhoneMobile()

            LEFT JOIN ObjectString AS  ObjectString_Phone
                                   ON  ObjectString_Phone.ObjectId = Object_Client.Id
                                  AND  ObjectString_Phone.DescId = zc_ObjectString_Client_Phone()

            LEFT JOIN ObjectString AS  ObjectString_Mail
                                   ON  ObjectString_Mail.ObjectId = Object_Client.Id
                                  AND  ObjectString_Mail.DescId = zc_ObjectString_Client_Mail()

            LEFT JOIN ObjectString AS  ObjectString_Comment
                                   ON  ObjectString_Comment.ObjectId = Object_Client.Id
                                  AND  ObjectString_Comment.DescId = zc_ObjectString_Client_Comment()
            LEFT JOIN ObjectLink AS ObjectLink_Client_LastUser
                                 ON ObjectLink_Client_LastUser.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_LastUser.DescId = zc_ObjectLink_Client_LastUser()
            LEFT JOIN Object AS Object_LastUser ON Object_LastUser.Id = ObjectLink_Client_LastUser.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                                 ON ObjectLink_User_Unit.ObjectId = Object_LastUser.Id
                                AND ObjectLink_User_Unit.DescId   = zc_ObjectLink_User_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Client_InsertUnit
                                 ON ObjectLink_Client_InsertUnit.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_InsertUnit.DescId   = zc_ObjectLink_Client_InsertUnit()
            LEFT JOIN Object AS Object_Unit_Insert ON Object_Unit_Insert.Id = ObjectLink_Client_InsertUnit.ChildObjectId
            LEFT JOIN tmpUnit_isOutlet ON tmpUnit_isOutlet.UnitId = ObjectLink_Client_InsertUnit.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Protocol_Insert
                                 ON ObjectLink_Protocol_Insert.ObjectId = Object_Client.Id
                                AND ObjectLink_Protocol_Insert.DescId   = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_User_Insert ON Object_User_Insert.Id = ObjectLink_Protocol_Insert.ChildObjectId
            LEFT JOIN ObjectDate AS  ObjectDate_Protocol_Insert
                                  ON ObjectDate_Protocol_Insert.ObjectId = Object_Client.Id
                                 AND ObjectDate_Protocol_Insert.DescId   = zc_ObjectDate_Protocol_Insert()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Client_Outlet
                                    ON ObjectBoolean_Client_Outlet.ObjectId = Object_Client.Id
                                   AND ObjectBoolean_Client_Outlet.DescId   = zc_ObjectBoolean_Client_Outlet()

            LEFT JOIN tmpContainer ON tmpContainer.ClientId = Object_Client.Id

     WHERE Object_Client.DescId = zc_Object_Client()
       AND (Object_Client.isErased = FALSE OR inIsShowAll = TRUE)
       AND (((tmpUnit_isOutlet.UnitId > 0 OR ObjectBoolean_Client_Outlet.ValueData = TRUE) AND vbIsOutlet = TRUE)
         OR (tmpUnit_isOutlet.UnitId IS NULL AND vbIsOutlet = FALSE)
         OR inUnitId = 0
           )
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
26.03.2017        *
17.09.2017        *
09.05.2017                                                           *
28.02.2017                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Client (0, TRUE, zfCalc_UserAdmin())
