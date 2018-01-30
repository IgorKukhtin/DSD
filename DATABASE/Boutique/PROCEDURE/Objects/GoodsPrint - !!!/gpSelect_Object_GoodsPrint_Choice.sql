-- Function: gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPrint_Choice(
    IN inUserId      Integer,       --  ����������
    IN inSession     TVarChar       --  ������ ������������
)
RETURNS TABLE (Id                   Integer
             , Amount               TFloat
             , Name                 TVarChar
             , UserId               Integer
             , UserName             TVarChar
             , InsertDate           TDateTime
 )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsPrint());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY
       SELECT
             ROW_NUMBER() OVER (PARTITION BY Object_GoodsPrint.UserId ORDER BY Object_GoodsPrint.InsertDate) :: Integer AS Id
           , SUM (Object_GoodsPrint.Amount) :: TFloat AS Amount
           , ('���-��: <' || (SUM (Object_GoodsPrint.Amount) :: Integer) :: TVarChar || '>'
                     ||' <' || zfConvert_DateTimeToString (Object_GoodsPrint.InsertDate) || '>'
                     ||' <' || Object_User.ValueData || '>'
              ) :: TVarChar AS Name
           , Object_GoodsPrint.UserId      AS UserId
           , Object_User.ValueData         AS UserName
           , DATE_TRUNC ('SECOND', Object_GoodsPrint.InsertDate) :: TDateTime AS InsertDate

       FROM Object_GoodsPrint
            LEFT JOIN Object AS Object_User ON Object_User.Id = Object_GoodsPrint.UserId
       WHERE Object_GoodsPrint.UserId = inUserId OR inUserId = 0
       GROUP BY Object_GoodsPrint.InsertDate
              , Object_GoodsPrint.UserId
              , Object_User.ValueData
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
17.08.17          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsPrint_Choice (0, zfCalc_UserAdmin())
