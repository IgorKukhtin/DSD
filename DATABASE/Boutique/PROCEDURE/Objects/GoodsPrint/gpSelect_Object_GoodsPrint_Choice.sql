-- Function: gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPrint_Choice(
    IN inUserId      Integer,       --  ���������� 
    IN inSession     TVarChar       --  ������ ������������
)
RETURNS TABLE (Id                   Integer
             , UnitId               Integer
             , UnitName             TVarChar
             , UserId               Integer
             , UserName             TVarChar
             , Amount               TFloat
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
       SELECT DISTINCT
             Object_GoodsPrint.Id           AS Id
           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , Object_User.Id                 AS UserId
           , Object_User.ValueData          AS UserName 
           , Object_GoodsPrint.Amount       AS Amount       
           , Object_GoodsPrint.InsertDate   AS InsertDate
                      
       FROM Object_GoodsPrint
            
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id        = Object_GoodsPrint.UnitId 
            LEFT JOIN Object AS Object_User ON Object_User.Id        = Object_GoodsPrint.UserId 
            
     WHERE Object_GoodsPrint.UserId = inUserId OR inUserId = 0
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