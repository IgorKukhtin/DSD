-- Function: lpInsertUpdate_MovementItemLinkObject

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemLinkObject (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemLinkObject(
    IN inDescId                Integer           , -- ���� ������ ��������
    IN inMovementItemId        Integer           , -- ���� 
    IN inObjectId              Integer             -- ���� �������
)
RETURNS Boolean
AS
$BODY$
BEGIN
    IF inObjectId = 0
    THEN
        inObjectId := NULL;
    END IF;

    -- �������� <��������>
    UPDATE MovementItemLinkObject SET ObjectId = inObjectId WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

    -- ���� �� �����
    IF NOT FOUND AND inObjectId IS NOT NULL
    THEN
        -- �������� <��������>
        INSERT INTO MovementItemLinkObject (DescId, MovementItemId, ObjectId)
                                    VALUES (inDescId, inMovementItemId, inObjectId);
    /*ELSE
        -- ��������� �������� - !!!����� ������!!!
        IF inDescId = zc_MILinkObject_Receipt()
        THEN
            IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = inMovementItemId AND MovementItem.MovementId = 17266213)
            THEN
                RAISE EXCEPTION '������.<%>  %  %  %', inObjectId
                , lfGet_Object_ValueData((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = inMovementItemId AND MovementItem.MovementId = 17266213))
                , lfGet_Object_ValueData((SELECT M.ObjectId FROM MovementItemLinkObject AS M WHERE M.MovementItemId = inMovementItemId AND M.DescId = zc_MILinkObject_GoodsKind()))
                , lfGet_Object_ValueData((SELECT M.ObjectId FROM MovementItemLinkObject AS M WHERE M.MovementItemId = inMovementItemId AND M.DescId = zc_MILinkObject_GoodsKindComplete()))
                ;
            END IF;
            --
            PERFORM lpInsert_MovementItemProtocol (inMovementItemId, zc_Enum_Process_Auto_PrimeCost() :: Integer, FALSE);
        END IF;*/
    END IF;             

    RETURN TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemLinkObject (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.03.15                                        * IF ... AND inObjectId IS NOT NULL
*/

-- ����
