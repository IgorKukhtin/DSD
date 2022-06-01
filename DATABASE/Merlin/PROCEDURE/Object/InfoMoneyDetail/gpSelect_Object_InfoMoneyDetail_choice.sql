-- Function: gpSelect_Object_InfoMoneyDetail_choice()

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyDetail_choice (Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyDetail_choice (Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyDetail_choice(
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ���
    IN inKindName    TVarChar,      -- ����� ������ ���������� ������ ������ ��� ������ ������ 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isUserAll Boolean
             , isErased Boolean
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoney());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT tmp.Id          AS Id 
        , tmp.Code
        , tmp.Name
        , tmp.isUserAll
        , tmp.isErased
        
        , tmp.InfoMoneyKindId
        , tmp.InfoMoneyKindName

   FROM gpSelect_Object_InfoMoneyDetail (inIsShowAll, inSession) AS tmp
   /*WHERE ((inKindName = 'zc_Enum_InfoMoney_In' AND (tmp.InfoMoneyKindId = zc_Enum_InfoMoney_In() OR COALESCE (tmp.InfoMoneyKindId,0)=0) ) 
      OR (inKindName = 'zc_Enum_InfoMoney_Out' AND (tmp.InfoMoneyKindId = zc_Enum_InfoMoney_Out() OR COALESCE (tmp.InfoMoneyKindId,0)=0) )
      OR COALESCE (inKindName,'') = ''  
        )*/
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.01.22         * inKindName
 14.01.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_InfoMoneyDetail (TRUE, zfCalc_UserAdmin())