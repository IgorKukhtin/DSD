-- Function: gpGet_MovementItem_ChoiceCell()

DROP FUNCTION IF EXISTS gpGet_MovementItem_ChoiceCell (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_ChoiceCell(
    IN inBarCode             TVarChar  , -- �������� ��. ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (ChoiceCellId Integer, ChoiceCellCode Integer, ChoiceCellName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , PartionGoodsDate TDateTime, PartionGoodsDate_next TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbChoiceCellId Integer;
   DECLARE vbOperDate     TDateTime;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ���� ���� �����
     IF COALESCE (inBarCode,'') <> ''
     THEN
         -- �� ����
         IF CHAR_LENGTH (inBarCode) < 12
         THEN vbChoiceCellId:= (WITH tmpObject AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_ChoiceCell() AND Object.isErased = FALSE)
                                SELECT Object.Id
                                FROM (SELECT zfConvert_StringToNumber (inBarCode) AS ObjectCode
                                     ) AS tmp
                                      INNER JOIN tmpObject AS Object ON Object.ObjectCode = tmp.ObjectCode
                                                                  --AND Object.DescId = zc_Object_ChoiceCell()
                                                                  --AND Object.isErased = FALSE
                                WHERE tmp.ObjectCode > 0
                                );

         -- �� ����� ����
         ELSEIF CHAR_LENGTH (inBarCode) = 12
         THEN
              vbChoiceCellId:= (WITH tmpObject AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_ChoiceCell() AND Object.isErased = FALSE)
                                SELECT Object.Id
                                FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS ObjectId
                                     ) AS tmp
                                      INNER JOIN tmpObject AS Object ON Object.Id = tmp.ObjectId
                                                                  --AND Object.DescId = zc_Object_ChoiceCell()
                                                                  --AND Object.isErased = FALSE
                               );
         END IF;

     END IF;


     -- ��������
     IF COALESCE (vbChoiceCellId, 0) = 0
     THEN
        --
         RAISE EXCEPTION '������.������ ������ � % <%> �� �������.'
                        , CASE WHEN CHAR_LENGTH (inBarCode) < 12 THEN '�����' ELSE '����������' END
                        , inBarCode;
     END IF;


     -- ����� ����� �������� ��� ���� ������ ������
     SELECT COALESCE (ObjectLink_Goods.ChildObjectId, 0)       AS GoodsId
          , COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0)   AS GoodsKindId
            INTO vbGoodsId, vbGoodsKindId
     FROM ObjectLink AS ObjectLink_Goods
          LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                               ON ObjectLink_GoodsKind.ObjectId = ObjectLink_Goods.ObjectId
                              AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_ChoiceCell_GoodsKind()
     WHERE ObjectLink_Goods.ObjectId = vbChoiceCellId
       AND ObjectLink_Goods.DescId   = zc_ObjectLink_ChoiceCell_Goods()
    ;

     -- ���� � ����������� �� �����
     vbOperDate:= gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= 1, inSession:= inSession);


     -- ���������
     RETURN QUERY
        WITH -- ��� ����������� ����� �������� - ������ + ������ "�����"
             tmpPartionCell_mi AS (SELECT DISTINCT lpSelect.PartionCellId, lpSelect.GoodsId, lpSelect.GoodsKindId, lpSelect.PartionGoodsDate
                                   FROM lpSelect_Object_PartionCell_mi (inGoodsId    := CASE WHEN vbGoodsId > 0 THEN vbGoodsId ELSE -1 END
                                                                      , inGoodsKindId:= vbGoodsKindId
                                                                       ) AS lpSelect
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
        -- ���������
        SELECT
               Object_ChoiceCell.Id                   AS ChoiceCellId
             , Object_ChoiceCell.ObjectCode           AS ChoiceCellCode
             , Object_ChoiceCell.ValueData            AS ChoiceCellName
             , Object_Goods.Id                        AS GoodsId
             , Object_Goods.ObjectCode                AS GoodsCode
             , Object_Goods.ValueData                 AS GoodsName
             , Object_GoodsKind.Id                    AS GoodsKindId
             , Object_GoodsKind.ValueData             AS GoodsKindName
               -- ��������� ������ � ������ "�����"
             , tmpPartionCell_RK.PartionGoodsDate   :: TDateTime AS PartionGoodsDate
               -- ������ ������ � ������ ��������
             , tmpPartionCell_real.PartionGoodsDate :: TDateTime AS PartionGoodsDate_next

        FROM Object AS Object_ChoiceCell
             LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = vbGoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = vbGoodsKindId

             -- ��������� ������ � ������ "�����"
             LEFT JOIN tmpPartionCell_RK ON tmpPartionCell_RK.GoodsId     = vbGoodsId
                                        AND tmpPartionCell_RK.GoodsKindId = vbGoodsKindId
                                        AND tmpPartionCell_RK.ord         = 1
             -- ������ ������ � ������ ��������
             LEFT JOIN tmpPartionCell_real ON tmpPartionCell_real.GoodsId     = vbGoodsId
                                          AND tmpPartionCell_real.GoodsKindId = vbGoodsKindId
                                          AND tmpPartionCell_real.ord         = 1

        WHERE Object_ChoiceCell.DescId = zc_Object_ChoiceCell()
          AND Object_ChoiceCell.Id     = vbChoiceCellId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.08.24                                        *
*/

-- ����
-- SELECT * FROM gpGet_MovementItem_ChoiceCell ('201011041653', zfCalc_UserAdmin())
-- SELECT * FROM gpGet_MovementItem_ChoiceCell ('11', zfCalc_UserAdmin())
