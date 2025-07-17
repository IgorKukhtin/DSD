-- Function: gpGet_Scale_GoodsByGoodsKindPeresort_check()

DROP FUNCTION IF EXISTS gpGet_Scale_GoodsByGoodsKindPeresort_check (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_GoodsByGoodsKindPeresort_check(
    IN inGoodsId_in       Integer,
    IN inGoodsKindId_in   Integer,
    IN inGoodsId_out      Integer,
    IN inGoodsKindId_out  Integer,
    IN inBranchCode       Integer,      --
    IN inSession          TVarChar      -- ������ ������������
)
RETURNS TABLE (isOk        Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);


    -- ��������
    IF COALESCE (inGoodsId_in, 0) = 0
    THEN
        RAISE EXCEPTION '������.�� ���������� �������� <����� ������>.';
    END IF;

    -- ��������
    IF COALESCE (inGoodsKindId_in, 0) = 0
    THEN
        RAISE EXCEPTION '������.�� ���������� �������� <��� ������ ������>.';
    END IF;

    -- ��������
    IF COALESCE (inGoodsId_out, 0) = 0
    THEN
        RAISE EXCEPTION '������.�� ���������� �������� <����� ������>.';
    END IF;

    -- ��������
    IF COALESCE (inGoodsKindId_out, 0) = 0
    THEN
        RAISE EXCEPTION '������.�� ���������� �������� <��� ������ ������>.';
    END IF;


    -- ���������
    IF EXISTS (SELECT 1
               FROM ObjectLink AS OL_GoodsByGoodsKindPeresort_Goods_in
                    INNER JOIN Object AS Object_GoodsByGoodsKindPeresort ON Object_GoodsByGoodsKindPeresort.Id       = OL_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                                                        AND Object_GoodsByGoodsKindPeresort.isErased = FALSE
                    INNER JOIN ObjectLink AS OL_GoodsByGoodsKindPeresort_GoodsKind_in
                                          ON OL_GoodsByGoodsKindPeresort_GoodsKind_in.ObjectId      = OL_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                         AND OL_GoodsByGoodsKindPeresort_GoodsKind_in.DescId        = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in()
                                         AND OL_GoodsByGoodsKindPeresort_GoodsKind_in.ChildObjectId = inGoodsKindId_in

                    INNER JOIN ObjectLink AS OL_GoodsByGoodsKindPeresort_Goods_out
                                          ON OL_GoodsByGoodsKindPeresort_Goods_out.ObjectId      = OL_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                         AND OL_GoodsByGoodsKindPeresort_Goods_out.DescId        = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out()
                                         AND OL_GoodsByGoodsKindPeresort_Goods_out.ChildObjectId = inGoodsId_out
                    INNER JOIN ObjectLink AS OL_GoodsByGoodsKindPeresort_GoodsKind_out
                                         ON OL_GoodsByGoodsKindPeresort_GoodsKind_out.ObjectId      = OL_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                        AND OL_GoodsByGoodsKindPeresort_GoodsKind_out.DescId        = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out()
                                        AND OL_GoodsByGoodsKindPeresort_GoodsKind_out.ChildObjectId = inGoodsKindId_out

               WHERE OL_GoodsByGoodsKindPeresort_Goods_in.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in()
                 AND OL_GoodsByGoodsKindPeresort_Goods_in.ChildObjectId     = inGoodsId_in
              )

    THEN
        RETURN QUERY
          SELECT TRUE  :: Boolean AS isOk;
    ELSE
        RETURN QUERY
          SELECT FALSE :: Boolean AS isOk;
    END IF
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.07.25                                        *
*/

-- ����
-- SELECT * FROM gpGet_Scale_GoodsByGoodsKindPeresort_check (inGoodsId_in:= 1, inGoodsKindId_in:= 1, inGoodsId_out:= 1, inGoodsKindId_out:= 1, inBranchCode:= 0, inSession:=zfCalc_UserAdmin())
