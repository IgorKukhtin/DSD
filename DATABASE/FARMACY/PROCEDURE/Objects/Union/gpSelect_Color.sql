-- Function: gpSelect_Object_Juridical()

DROP FUNCTION IF EXISTS gpSelect_Color(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Color(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (ColorId Integer, ColorName TVarChar, Text1 TVarChar, Text2 TVarChar) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   RETURN QUERY 
       SELECT zc_Color_Black(),            'zc_Color_Black'             ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_Red(),              'zc_Color_Red'               ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_Aqua(),             'zc_Color_Aqua'              ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_Cyan(),             'zc_Color_Cyan'              ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_GreenL(),           'zc_Color_GreenL'            ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_Yelow(),            'zc_Color_Yelow'             ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_White(),            'zc_Color_White'             ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_Blue(),             'zc_Color_Blue'              ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_Goods_Additional(), 'zc_Color_Goods_Additional'  ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_Goods_Alternative(),'zc_Color_Goods_Alternative' ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_Warning_Red(),      'zc_Color_Warning_Red'       ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 UNION SELECT zc_Color_Warning_Navy(),     'zc_Color_Warning_Navy'      ::TVarChar, '�����' ::TVarChar, '���' ::TVarChar
 ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.16         *

*/

-- ����
-- SELECT * FROM gpSelect_Color ('2')