-- Function: gpGet_Object_Unit(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Unit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- �������������
    IN inSession     TVarChar       -- ������ ������������
) 
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Address TVarChar, Phone TVarChar, Printer TVarChar
             , DiscountTax TFloat
             , JuridicalId Integer, JuridicalName TVarChar
             , ParentId Integer, ParentName TVarChar
             , ChildId Integer, ChildName  TVarChar
             , BankAccountId Integer, BankAccountName  TVarChar
             , AccountDirectionId Integer, AccountDirectionName TVarChar
) 
AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                          AS Id
           , lfGet_ObjectCode(0, zc_Object_Unit())  AS Code
           , '' :: TVarChar                         AS Name
           , '' :: TVarChar                         AS Address
           , '' :: TVarChar                         AS Phone
           , '' :: TVarChar                         AS Printer
           ,  0 :: TFloat                           AS DiscountTax
           ,  0 :: Integer                          AS JuridicalId      
           , '' :: TVarChar                         AS JuridicalName    
           ,  0 :: Integer                          AS ParentId         
           , '' :: TVarChar                         AS ParentName       
           ,  0 :: Integer                          AS ChildId          
           , '' :: TVarChar                         AS ChildName        
           ,  0 :: Integer                          AS BankAccountId          
           , '' :: TVarChar                         AS BankAccountName        
           ,  0 :: Integer                          AS AccountDirectionId
           , '' :: TVarChar                         AS AccountDirectionName 
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , Object_Unit.ValueData           AS Name
           , OS_Unit_Address.ValueData       AS Address
           , OS_Unit_Phone.ValueData         AS Phone
           , OS_Unit_Printer.ValueData       AS Printer
           , OS_Unit_DiscountTax.ValueData   AS DiscountTax
           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_Parent.Id                AS ParentId
           , Object_Parent.ValueData         AS ParentName
           , Object_Child.Id                 AS ChildId
           , Object_Child.ValueData          AS ChildName
           , Object_BankAccount.Id           AS BankAccountId
           , Object_BankAccount.ValueData    AS BankAccountName

           , Object_AccountDirection.Id         AS AccountDirectionId
           , Object_AccountDirection.ValueData  AS AccountDirectionName       
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

            LEFT JOIN ObjectFloat AS OS_Unit_DiscountTax
                                  ON OS_Unit_DiscountTax.ObjectId = Object_Unit.Id
                                 AND OS_Unit_DiscountTax.DescId = zc_ObjectFloat_Unit_DiscountTax()

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

            LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                 ON ObjectLink_Unit_AccountDirection.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
            LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Unit_AccountDirection.ChildObjectId

      WHERE Object_Unit.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
27.02.18          * Printer
07.06.17          * add AccountDirection
10.05.17                                                          *
08.05.17                                                          *
06.03.17                                                          *
28.02.17                                                          *
 
*/

-- ����
-- SELECT * FROM gpGet_Object_Unit(1,'2')