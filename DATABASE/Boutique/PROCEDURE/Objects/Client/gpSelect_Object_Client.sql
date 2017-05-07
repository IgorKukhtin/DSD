-- ����������

DROP FUNCTION IF EXISTS gpSelect_Object_Client (Bolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Client(
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ��� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DiscountCard TVarChar, DiscountTax TFloat, DiscountTaxTwo TFloat, TotalCount TFloat, TotalSumm TFloat, TotalSummDiscount TFloat, TotalSummPay TFloat, LastCount TFloat, LastSumm TFloat, LastSummDiscount TFloat, LastDate TDateTime, Address TVarChar, HappyDate TDateTime, PhoneMobile TVarChar, Phone TVarChar, Mail TVarChar, Comment TVarChar, CityName TVarChar, DiscountKindName TVarChar, isErased boolean) 
  AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Client());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_Client.Id                        AS Id
           , Object_Client.ObjectCode                AS Code
           , Object_Client.ValueData                 AS Name
           , ObjectString_DiscountCard.ValueData     AS DiscountCard
           , ObjectFloat_DiscountTax.ValueData       AS DiscountTax
           , ObjectFloat_DiscountTaxTwo.ValueData    AS DiscountTaxTwo
           , ObjectFloat_TotalCount.ValueData        AS TotalCount
           , ObjectFloat_TotalSumm.ValueData         AS TotalSumm
           , ObjectFloat_TotalSummDiscount.ValueData AS TotalSummDiscount
           , ObjectFloat_TotalSummPay.ValueData      AS TotalSummPay
           , ObjectFloat_LastCount.ValueData         AS LastCount
           , ObjectFloat_LastSumm.ValueData          AS LastSumm
           , ObjectFloat_LastSummDiscount.ValueData  AS LastSummDiscount
           , ObjectDate_LastDate.ValueData           AS LastDate
           , ObjectString_Address.ValueData          AS Address
           , ObjectDate_HappyDate.ValueData          AS HappyDate
           , ObjectString_PhoneMobile.ValueData      AS PhoneMobile
           , ObjectString_Phone.ValueData            AS Phone
           , ObjectString_Mail.ValueData             AS Mail
           , ObjectString_Comment.ValueData          AS Comment
           , Object_City.ValueData                   AS CityName
           , Object_DiscountKind.ValueData           AS DiscountKindName
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
      
     WHERE Object_Client.DescId = zc_Object_Client()
              AND (Object_Client.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
28.02.2017                                                           *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Client (TRUE, zfCalc_UserAdmin())