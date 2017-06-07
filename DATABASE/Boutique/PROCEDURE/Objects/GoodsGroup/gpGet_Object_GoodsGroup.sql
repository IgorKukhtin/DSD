-- Function: gpGet_Object_GoodsGroup()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroup(
    IN inId          Integer,       -- ������ ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
) 
AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             0  :: Integer                      AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsGroup())   AS Code
           , '' :: TVarChar                     AS Name
           , 0  :: Integer                      AS GoodsGroupId
           , '' :: TVarChar                     AS GoodsGroupName
           , 0  :: Integer                      AS InfoMoneyId
           , '' :: TVarChar                     AS InfoMoneyName
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_GoodsGroup.Id               AS Id
           , Object_GoodsGroup.ObjectCode       AS Code
           , Object_GoodsGroup.ValueData        AS Name    
           , Object_Parent.Id                   AS GoodsGroupId
           , Object_Parent.ValueData            AS GoodsGroupName
           , Object_InfoMoney.Id                AS InfoMoneyId
           , Object_InfoMoney.ValueData         AS InfoMoneyName
       FROM Object AS Object_GoodsGroup
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                 ON ObjectLink_GoodsGroup_Parent.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                 ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_GoodsGroup_InfoMoney.ChildObjectId

       WHERE Object_GoodsGroup.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
07.06.17          * add InfoMoney
06.03.17                                                          *
20.02.17                                                          *
 
*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsGroup(1,'2'::TVarChar)