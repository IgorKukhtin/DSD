-- Function: gpSelect_Object_ChoiceCell_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ChoiceCell (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ChoiceCell(
    IN inShowAll       Boolean , -- �������� ��������� ��/���
    IN inSession       TVarChar  -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_search TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , NPP Integer, BoxCount TFloat
             , Comment TVarChar
             , PartionGoodsDate_RK   TDateTime
             , PartionGoodsDate_real TDateTime
             , idBarCode TVarChar

             , isChoiceCell_mi Boolean
             , PartionGoodsDate_next_mi TDateTime
             , GoodsCode_mi Integer
             , GoodsName_mi TVarChar
             , GoodsKindName_mi TVarChar

             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);



     -- ���������
     RETURN QUERY
       WITH -- ��� ����������� ����� �������� - ������ + ������ "�����"
            tmpPartionCell_mi AS (SELECT DISTINCT lpSelect.PartionCellId, lpSelect.GoodsId, lpSelect.GoodsKindId, lpSelect.PartionGoodsDate
                                  FROM lpSelect_Object_PartionCell_mi (inGoodsId:= 0, inGoodsKindId:= 0) AS lpSelect
                                 )
            -- ������ ��������� ������ � ������ "�����"
          , tmpPartionCell_RK AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                         -- � �/�
                                       , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate DESC) AS Ord
                                  FROM tmpPartionCell_mi AS tmpMI
                                  -- ������ = ������ "�����"
                                  WHERE tmpMI.PartionCellId = zc_PartionCell_RK()
                                 )
          -- ������ ������ ������ � ������ ��������
       ,  tmpPartionCell_real AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                         -- � �/�
                                       , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate ASC) AS Ord
                                  FROM tmpPartionCell_mi AS tmpMI
                                  -- ������ = ������ ��������
                                  WHERE tmpMI.PartionCellId <> zc_PartionCell_RK()
                                 )
          -- ���� ������ - �������� ��� ������ � ��������
       ,  tmpChoiceCell_mi AS (SELECT lpSelect.ChoiceCellId, lpSelect.PartionGoodsDate_next, lpSelect.GoodsCode, lpSelect.GoodsName, lpSelect.GoodsKindName
                               FROM lpSelect_Movement_ChoiceCell_mi(vbUserId) AS lpSelect
                               WHERE lpSelect.Ord = 1
                              )
    -- ���������
    SELECT
           Object_ChoiceCell.Id          AS Id
         , Object_ChoiceCell.ObjectCode  AS Code
         , Object_ChoiceCell.ValueData   AS Name
         , (Object_ChoiceCell.ValueData ||'@'||REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (Object_ChoiceCell.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '')) :: TVarChar AS Name_search

         , Object_Goods.Id         AS GoodsId
         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData  AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_GoodsGroup.ValueData AS GoodsGroupName
         , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

       --, ObjectFloat_NPP.ValueData AS NPP
           -- !!!������!!!
         , Object_ChoiceCell.ObjectCode AS NPP
         , ObjectFloat_BoxCount.ValueData AS BoxCount

         , ObjectString_Comment.ValueData  AS Comment

           -- ��������� ������ � ������ "�����"
         , tmpPartionCell_RK.PartionGoodsDate   :: TDateTime AS PartionGoodsDate_RK
           -- ������ ������ � ������ ��������
         , tmpPartionCell_real.PartionGoodsDate :: TDateTime AS PartionGoodsDate_real

         , (zfFormat_BarCode (zc_BarCodePref_Object(), Object_ChoiceCell.Id)) ::TVarChar AS idBarCode
         
         , CASE WHEN tmpChoiceCell_mi.ChoiceCellId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isChoiceCell_mi
         , tmpChoiceCell_mi.PartionGoodsDate_next AS PartionGoodsDate_next_mi
         , tmpChoiceCell_mi.GoodsCode             AS GoodsCode_mi
         , tmpChoiceCell_mi.GoodsName             AS GoodsName_mi
         , tmpChoiceCell_mi.GoodsKindName         AS GoodsKindName_mi

         , Object_ChoiceCell.isErased      AS isErased

    FROM Object AS Object_ChoiceCell

        -- ������ - �������� ��� ������ � ��������
        LEFT JOIN tmpChoiceCell_mi ON tmpChoiceCell_mi.ChoiceCellId = Object_ChoiceCell.Id

        LEFT JOIN ObjectLink AS ObjectLink_Goods
                             ON ObjectLink_Goods.ObjectId = Object_ChoiceCell.Id
                            AND ObjectLink_Goods.DescId = zc_ObjectLink_ChoiceCell_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                             ON ObjectLink_GoodsKind.ObjectId = Object_ChoiceCell.Id
                            AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_ChoiceCell_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                              ON ObjectFloat_NPP.ObjectId = Object_ChoiceCell.Id
                             AND ObjectFloat_NPP.DescId = zc_ObjectFloat_ChoiceCell_NPP()

        LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                              ON ObjectFloat_BoxCount.ObjectId = Object_ChoiceCell.Id
                             AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_ChoiceCell_BoxCount()

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_ChoiceCell.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_ChoiceCell_Comment()
        --
        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

        -- ��������� ������ � ������ "�����"
        LEFT JOIN tmpPartionCell_RK ON tmpPartionCell_RK.GoodsId     = Object_Goods.Id
                                   AND tmpPartionCell_RK.GoodsKindId = Object_GoodsKind.Id
                                   AND tmpPartionCell_RK.ord         = 1
        -- ������ ������ � ������ ��������
        LEFT JOIN tmpPartionCell_real ON tmpPartionCell_real.GoodsId     = Object_Goods.Id
                                     AND tmpPartionCell_real.GoodsKindId = Object_GoodsKind.Id
                                     AND tmpPartionCell_real.ord         = 1

    WHERE Object_ChoiceCell.DescId = zc_Object_ChoiceCell()
      AND (Object_ChoiceCell.isErased = FALSE OR inShowAll = TRUE)
    ORDER BY Object_ChoiceCell.ObjectCode
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.24         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ChoiceCell (FALSE, zfCalc_UserAdmin())
