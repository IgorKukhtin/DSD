-- Function: gpGet_GlobalConst_SiteDiscount

DROP FUNCTION IF EXISTS gpGet_GlobalConst_SiteDiscount (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GlobalConst_SiteDiscount(
    IN     inSession          TVarChar  -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
BEGIN
     
     IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = zc_Enum_GlobalConst_SiteDiscount() AND OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_GlobalConst_SiteDiscount())
     THEN
         -- ���������
         RETURN ((SELECT 1 FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_GlobalConst_SiteDiscount() AND OFl.DescId = zc_ObjectFloat_GlobalConst_SiteDiscount()));
     ELSE
         -- ���������
         RETURN (0);
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.19                                        *
*/

-- ����
-- SELECT gpGet_GlobalConst_SiteDiscount (inSession:= zfCalc_UserAdmin())
