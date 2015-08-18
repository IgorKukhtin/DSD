-- Function: gpDelete_ObjectFloat_Goods_MinimumLot()

DROP FUNCTION IF EXISTS gpDelete_ObjectFloat_Goods_MinimumLot(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_ObjectFloat_Goods_MinimumLot(
    IN inObjectId            Integer   ,    -- ��� ����������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
    IF COALESCE(inObjectId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� ����������';
    END IF;
    DELETE FROM ObjectFloat
    WHERE
        DescId = zc_ObjectFloat_Goods_MinimumLot()
        AND
        ObjectId IN (
            Select DISTINCT 
                ObjectLink_Goods_Object.ObjectId
            FROM
                ObjectLink AS ObjectLink_Goods_Object
            WHERE
                ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                AND
                ObjectLink_Goods_Object.ChildObjectId = inObjectId);
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_ObjectFloat_Goods_MinimumLot(Integer, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 15.08.15                                                         *
 
*/