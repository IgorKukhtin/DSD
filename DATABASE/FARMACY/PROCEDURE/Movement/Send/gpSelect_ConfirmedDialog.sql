-- Function: gpSelect_ConfirmedDialog()

DROP FUNCTION IF EXISTS gpSelect_ConfirmedDialog(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ConfirmedDialog(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Name TVarChar, isConfirmed  Boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT 1::Integer                                AS Id 
        , '��������� <�����������>'::TVarChar       AS Name
        , True                                      AS isConfirmed
   UNION ALL
   SELECT 2::Integer
        , '��������� <�� �����������>'::TVarChar
        , False;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ConfirmedDialog(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.05.20                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_ConfirmedDialog('3')