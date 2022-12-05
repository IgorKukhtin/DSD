-- select *  from objectProtocol left join Object on Object.Id = UserId where objectProtocol.Objectid = 8109587 order by 1 desc
select Object.*, objectProtocol.OperDate from objectProtocol join Object on Object.Id = ObjectId and Object.DescId = 206
where objectProtocol.OperDate between '30.05.2022' and '31.05.2022' and isInsert = true
-- and object.id = 8109587
order by objectProtocol.OperDate desc



    INSERT INTO _replica.table_update_data (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, MovementId, ParentId, transaction_id, user_name)
        select 'public', 'object', 'id', Id, '', 'insert' as operation, null, null, 123, 'admin'
        from (

    INSERT INTO Object (id, descId, ObjectCode, ValueData, isErased)
       select a.Id, a.DescId, 0, '', false
       from (
select 8109582 as id, 206 as descId
union all select 8109583 as id, 206 as descId
union all select 8109585 as id, 206 as descId
union all select 8109580 as id, 206 as descId
union all select 8109586 as id, 206 as descId
union all select 8109587 as id, 206 as descId
union all select 8109595 as id, 206 as descId
union all select 8109588 as id, 206 as descId
union all select 8109590 as id, 206 as descId
union all select 8109598 as id, 206 as descId
union all select 8109579 as id, 206 as descId
union all select 8109589 as id, 206 as descId
union all select 8109593 as id, 206 as descId
union all select 8109578 as id, 206 as descId
union all select 8109581 as id, 206 as descId
union all select 8109596 as id, 206 as descId
union all select 8109591 as id, 206 as descId
union all select 8109594 as id, 206 as descId
union all select 8109584 as id, 206 as descId
union all select 8109592 as id, 206 as descId
union all select 8109597 as id, 206 as descId

) as a
left join Object on Object.Id = a.Id
where Object.Id is null
order by a.Id


