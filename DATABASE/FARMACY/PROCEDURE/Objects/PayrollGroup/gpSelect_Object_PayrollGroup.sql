-- Function: gpSelect_Object_PayrollGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_PayrollGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PayrollGroup(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BankPOSTerminal()());

   RETURN QUERY
   SELECT
          Object_BankPOSTerminal.Id         AS Id
        , Object_BankPOSTerminal.ObjectCode AS Code
        , Object_BankPOSTerminal.ValueData  AS Name

        , Object_BankPOSTerminal.isErased   AS isErased
   FROM Object AS Object_BankPOSTerminal
   WHERE Object_BankPOSTerminal.DescId = zc_Object_PayrollGroup();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.08.19                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PayrollGroup('3')