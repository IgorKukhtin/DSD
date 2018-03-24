-- Function: gpSelect_MI_Sale_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_Sale_BarCode (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Sale_BarCode(
     IN inBarCode              TVarChar,
     IN inBarCode_partner      TVarChar,
     IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (BarCode TVarChar, BarCode_partner TVarChar, BarCode_old TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- �������� ��� ������������ - � ������ ������������� �� ��������
     vbUnitId:= lpGetUnit_byUser (vbUserId);


     -- ���� �����-��� ���������� - ����������
     IF EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = vbUnitId AND ObjectBoolean.DescId = zc_ObjectBoolean_Unit_PartnerBarCode() AND ObjectBoolean.ValueData = TRUE)
     THEN
         IF COALESCE (inBarCode, '') <> '' AND COALESCE (inBarCode_partner, '') <> ''
         THEN
             -- ��������
             RETURN QUERY
               SELECT NULL :: TVarChar AS BarCode
                    , NULL :: TVarChar AS BarCode_partner
                    , NULL :: TVarChar AS BarCode_old
              ;

         ELSE
             -- ������ ��������
             RETURN QUERY
               SELECT COALESCE (inBarCode, '')         :: TVarChar  AS BarCode
                    , COALESCE (inBarCode_partner, '') :: TVarChar  AS BarCode_str
                    , COALESCE (inBarCode, '')         :: TVarChar  AS BarCode_old
              ;

         END IF;

     ELSE
         -- �������� - ������
         RETURN QUERY
           SELECT NULL :: TVarChar AS BarCode
                , NULL :: TVarChar AS BarCode_partner
                , NULL :: TVarChar AS BarCode_old
          ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 29.12.17         *
*/

-- ����
-- SELECT * FROM gpSelect_MI_Sale_BarCode (inBarCode:= '', inBarCode_partner:= '', inSession:= zfCalc_UserAdmin());
