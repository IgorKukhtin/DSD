-- Function: gpSelect_Object_GoodsGroup (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroup (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroup(
    IN inIsShowAll   Boolean,       --  ������� �������� ��������� �� / ��� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_choice TVarChar
             , ParentId Integer, GoodsGroupName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , isErased boolean) 
  AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsGroup());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
       SELECT 
             Object_GoodsGroup.Id               AS Id
           , Object_GoodsGroup.ObjectCode       AS Code
           , Object_GoodsGroup.ValueData        AS Name
           , (COALESCE (Object_Parent_2.ValueData || ' ', '')
           || COALESCE (Object_Parent_1.ValueData || ' ', '')
           || COALESCE (Object_Parent.ValueData   || ' ', '')
           || Object_GoodsGroup.ValueData
             )                      :: TVarChar AS Name_choice
           , Object_Parent.Id                   AS ParentId
           , Object_Parent.ValueData            AS GoodsGroupName
           , Object_InfoMoney.Id                AS InfoMoneyId
           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , Object_GoodsGroup.isErased         AS isErased
           
       FROM Object AS Object_GoodsGroup
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                 ON ObjectLink_GoodsGroup_Parent.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                 ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_GoodsGroup_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_1
                                 ON ObjectLink_GoodsGroup_Parent_1.ObjectId = ObjectLink_GoodsGroup_Parent.ChildObjectId
                                AND ObjectLink_GoodsGroup_Parent_1.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent_1 ON Object_Parent_1.Id = ObjectLink_GoodsGroup_Parent_1.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_2
                                 ON ObjectLink_GoodsGroup_Parent_2.ObjectId = ObjectLink_GoodsGroup_Parent_1.ChildObjectId
                                AND ObjectLink_GoodsGroup_Parent_2.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent_2 ON Object_Parent_2.Id = ObjectLink_GoodsGroup_Parent_2.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_3
                                 ON ObjectLink_GoodsGroup_Parent_3.ObjectId = ObjectLink_GoodsGroup_Parent_2.ChildObjectId
                                AND ObjectLink_GoodsGroup_Parent_3.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent_3 ON Object_Parent_3.Id = ObjectLink_GoodsGroup_Parent_3.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_4
                                 ON ObjectLink_GoodsGroup_Parent_4.ObjectId = ObjectLink_GoodsGroup_Parent_3.ChildObjectId
                                AND ObjectLink_GoodsGroup_Parent_4.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent_4 ON Object_Parent_4.Id = ObjectLink_GoodsGroup_Parent_4.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_5
                                 ON ObjectLink_GoodsGroup_Parent_5.ObjectId = ObjectLink_GoodsGroup_Parent_4.ChildObjectId
                                AND ObjectLink_GoodsGroup_Parent_5.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent_5 ON Object_Parent_5.Id = ObjectLink_GoodsGroup_Parent_5.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_6
                                 ON ObjectLink_GoodsGroup_Parent_6.ObjectId = ObjectLink_GoodsGroup_Parent_5.ChildObjectId
                                AND ObjectLink_GoodsGroup_Parent_6.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent_6 ON Object_Parent_6.Id = ObjectLink_GoodsGroup_Parent_6.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_7
                                 ON ObjectLink_GoodsGroup_Parent_7.ObjectId = ObjectLink_GoodsGroup_Parent_6.ChildObjectId
                                AND ObjectLink_GoodsGroup_Parent_7.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent_7 ON Object_Parent_7.Id = ObjectLink_GoodsGroup_Parent_7.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_8
                                 ON ObjectLink_GoodsGroup_Parent_8.ObjectId = ObjectLink_GoodsGroup_Parent_7.ChildObjectId
                                AND ObjectLink_GoodsGroup_Parent_8.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent_8 ON Object_Parent_8.Id = ObjectLink_GoodsGroup_Parent_8.ChildObjectId

     WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup()
       AND (Object_GoodsGroup.isErased = FALSE OR inIsShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
07.06.17          * add InfoMoney
07.03.17                                                            *
20.02.17                                                            *

        
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsGroup (TRUE, zfCalc_UserAdmin())
