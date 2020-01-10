-- Function: gpSelect_Object_Unit (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Unit (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Address TVarChar, Phone TVarChar
             , Printer TVarChar, PrintName TVarChar
             , DiscountTax TFloat
             , JuridicalName TVarChar, ParentName TVarChar, ChildName TVarChar
             , BankAccountName TVarChar, BankName TVarChar
             , AccountDirectionName TVarChar
             , GoodsGroupName  TVarChar
             , StartDate_sybase TDateTime
             , isPartnerBarCode Boolean
             , isOLAP Boolean
             , isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY
       WITH tmpReportOLAP AS (SELECT ObjectLink_Object.ChildObjectId AS UnitId
                              FROM Object
                                   INNER JOIN ObjectLink AS ObjectLink_User
                                                         ON ObjectLink_User.ObjectId      = Object.Id
                                                        AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                        AND ObjectLink_User.ChildObjectId = vbUserId
                                   INNER JOIN ObjectLink AS ObjectLink_Object
                                                         ON ObjectLink_Object.ObjectId    = Object.Id
                                                        AND ObjectLink_Object.DescId      = zc_ObjectLink_ReportOLAP_Object()
                              WHERE Object.DescId     = zc_Object_ReportOLAP()
                                AND Object.ObjectCode = zc_ReportOLAP_Unit()
                                AND Object.isErased   = FALSE
                             )

       SELECT
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , Object_Unit.ValueData           AS Name
           , OS_Unit_Address.ValueData       AS Address
           , OS_Unit_Phone.ValueData         AS Phone
           , OS_Unit_Printer.ValueData       AS Printer
           , OS_Unit_Print.ValueData         AS PrintName
           , OF_Unit_DiscountTax.ValueData   AS DiscountTax
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_Parent.ValueData         AS ParentName
           , Object_Child.ValueData          AS ChildName
           , Object_BankAccount.ValueData    AS BankAccountName
           , Object_Bank.ValueData           AS BankName

           , Object_AccountDirection.ValueData  AS AccountDirectionName
           
           , Object_GoodsGroup.ValueData    AS GoodsGroupName

           , CASE WHEN Object_Unit.ValueData = '������� MaxMara'
                       THEN '2006-01-01' -- MaxMara -- OK

                  WHEN Object_Unit.ValueData = '������� Terri-Luxury'
                       THEN '2007-04-28' -- TerryL  -- 30762 + 32257(M) + 35078(XS) + 41063(36) + 65813(40) + 77309(XS) in (54663,46751,42986,71924,192757,155479)

                  WHEN Object_Unit.ValueData = '������� 5 �������'
                       THEN '2007-04-01' -- 5 Elem  -- 28025(36) in (36477)

                  WHEN Object_Unit.ValueData = '������� CHADO'
                       THEN '2007-12-03' -- Chado   -- 70064 + 39629(I) + 103288(m12) in (169245,67594,284803) 

                  WHEN Object_Unit.ValueData = '������� SAVOY'
                       THEN '2008-03-31' -- Savoy   -- OK

                  WHEN Object_Unit.ValueData = '������� Savoy-P.Z.'
                       THEN '2008-03-01' -- PZ      -- OK

                  WHEN Object_Unit.ValueData = '������� �����-Out'
                       THEN '2007-04-28' -- Terry   -- OK -- 30762 + 32257(M) + 35978(XS) + 41063(36) in (54663,46751,42986,71924)

                  WHEN Object_Unit.ValueData = '������� Vintag'
                       THEN '2011-03-31' -- Vintag  -- OK

                  -- WHEN Object_Unit.ValueData = '������� Vintag 50'
                  --      THEN '2011-03-31' -- Vintag  -- OK
                  -- WHEN Object_Unit.ValueData = '������� Vintag 80'
                  --      THEN '2011-03-31' -- Vintag  -- OK
                  -- WHEN Object_Unit.ValueData = '������� Vintag 90'
                  --      THEN '2011-03-31' -- Vintag  -- OK

                  WHEN Object_Unit.ValueData = '������� ESCADA'
                       THEN '2012-04-01' -- Escada  -- OK

                  WHEN Object_Unit.ValueData = '������� Savoy-O'
                       THEN '2008-03-31' -- Savoy-2 -- OK

                  WHEN Object_Unit.ValueData = '������� Terry-Vintage'
                       THEN '2014-01-13' -- Sopra   -- OK

                  WHEN Object_Unit.ValueData = '������� Chado-Outlet'
                       THEN '2014-01-13' -- 11      -- OK

             END :: TDateTime AS StartDate_sybase

           , COALESCE (ObjectBoolean_PartnerBarCode.ValueData, FALSE) :: Boolean  AS isPartnerBarCode
           
           , CASE WHEN tmpReportOLAP.UnitId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isOLAP

           , Object_Unit.isErased            AS isErased

       FROM Object AS Object_Unit
            LEFT JOIN ObjectString AS OS_Unit_Address
                                   ON OS_Unit_Address.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Address.DescId = zc_ObjectString_Unit_Address()
            LEFT JOIN ObjectString AS OS_Unit_Phone
                                   ON OS_Unit_Phone.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()
            LEFT JOIN ObjectString AS OS_Unit_Printer
                                   ON OS_Unit_Printer.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Printer.DescId = zc_ObjectString_Unit_Printer()
            LEFT JOIN ObjectString AS OS_Unit_Print
                                   ON OS_Unit_Print.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Print.DescId = zc_ObjectString_Unit_Print()

            LEFT JOIN ObjectFloat AS OF_Unit_DiscountTax
                                  ON OF_Unit_DiscountTax.ObjectId = Object_Unit.Id
                                 AND OF_Unit_DiscountTax.DescId = zc_ObjectFloat_Unit_DiscountTax()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartnerBarCode 
                                    ON ObjectBoolean_PartnerBarCode.ObjectId = Object_Unit.Id 
                                   AND ObjectBoolean_PartnerBarCode.DescId = zc_ObjectBoolean_Unit_PartnerBarCode()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Child
                                 ON ObjectLink_Unit_Child.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Child.DescId = zc_ObjectLink_Unit_Child()
            LEFT JOIN Object AS Object_Child ON Object_Child.Id = ObjectLink_Unit_Child.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_BankAccount
                                 ON ObjectLink_Unit_BankAccount.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_BankAccount.DescId = zc_ObjectLink_Unit_BankAccount()
            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Unit_BankAccount.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                 ON ObjectLink_Unit_AccountDirection.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
            LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Unit_AccountDirection.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_GoodsGroup
                                 ON ObjectLink_Unit_GoodsGroup.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_GoodsGroup.DescId = zc_ObjectLink_Unit_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Unit_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                                 ON ObjectLink_User_Unit.ObjectId = vbUserId
                                AND ObjectLink_User_Unit.DescId   = zc_ObjectLink_User_Unit()

            LEFT JOIN tmpReportOLAP ON tmpReportOLAP.UnitId = Object_Unit.Id

     WHERE Object_Unit.DescId = zc_Object_Unit()
       AND (Object_Unit.isErased = FALSE OR inIsShowAll = TRUE)
       -- AND (Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId OR ObjectLink_User_Unit.ChildObjectId IS NULL)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
27.07.18          *
22.03.18          *
05.03.18          *
27.02.18          * Printer
07.06.17          * add AccountDirection
10.05.17                                                           *
08.05.17                                                           *
28.02.17                                                           *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Unit (TRUE, zfCalc_UserAdmin())
