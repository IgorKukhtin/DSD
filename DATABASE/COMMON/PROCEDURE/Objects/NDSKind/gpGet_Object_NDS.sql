-- Function: gpGet_Object_NDS (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_NDS (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_NDS(
    IN inNDSKindId      Integer   ,    -- ��� ���
   OUT outNDS           TFloat    ,    -- ���
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TFloat AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_NDSKind());

    IF NOT EXISTS(SELECT 1
                  FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                  WHERE ObjectFloat_NDSKind_NDS.ObjectId = inNDSKindId
                    AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()) 
    THEN
        RAISE EXCEPTION '������. �� ������ ���.';
    END IF;

   SELECT
     ObjectFloat_NDSKind_NDS.ValueData   AS NDS
   INTO
     outNDS      
   FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
   WHERE ObjectFloat_NDSKind_NDS.ObjectId = inNDSKindId
     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS();     
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_NDS (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 25.01.21                                                       *

*/

-- ����
-- SELECT * FROM gpGet_Object_NDS(9, '2')


