with tmp as (
 select p.OperDate, 1 as num , p.id , 'object' as table_name, 'id' as pk_keys, p.ObjectId :: TVarChar as pk_values from objectProtocol as p where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 

union all
 select p.OperDate, 2 as num , p.id , 'movement' as table_name, 'id' as pk_keys, p.MovementId :: TVarChar as pk_values from MovementProtocol as p where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 

union all
 select p.OperDate, 3 as num  , p.id , 'movementItem' as table_name, 'id' as pk_keys, p.MovementItemId :: TVarChar as pk_values from MovementItemProtocol as p where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 


union all
 select p.OperDate, 11 as num , p.id , 'ObjectFloat' as table_name, '{descid, objectid}' as pk_keys,  '{' || ObjectFloat.DescId :: TVarChar ||', ' || p.ObjectId :: TVarChar || '}' as pk_values from objectProtocol as p join ObjectFloat on ObjectFloat.ObjectId = p.ObjectId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 11 as num , p.id , 'ObjectDate' as table_name, '{descid, objectid}' as pk_keys,  '{' || ObjectDate.DescId :: TVarChar ||', ' || p.ObjectId :: TVarChar || '}' as pk_values from objectProtocol as p join ObjectDate on ObjectDate.ObjectId = p.ObjectId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 11 as num , p.id , 'ObjectString' as table_name, '{descid, objectid}' as pk_keys,  '{' || ObjectString.DescId :: TVarChar ||', ' || p.ObjectId :: TVarChar || '}' as pk_values from objectProtocol as p join ObjectString on ObjectString.ObjectId = p.ObjectId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 11 as num , p.id , 'ObjectBoolean' as table_name, '{descid, objectid}' as pk_keys,  '{' || ObjectBoolean.DescId :: TVarChar ||', ' || p.ObjectId :: TVarChar || '}' as pk_values from objectProtocol as p join ObjectBoolean on ObjectBoolean.ObjectId = p.ObjectId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 11 as num , p.id , 'ObjectLink' as table_name, '{descid, objectid}' as pk_keys,  '{' || ObjectLink.DescId :: TVarChar ||', ' || p.ObjectId :: TVarChar || '}' as pk_values from objectProtocol as p join ObjectLink on ObjectLink.ObjectId = p.ObjectId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 



union all
 select p.OperDate, 22 as num , p.id , 'MovementFloat' as table_name, '{descid, movementid}' as pk_keys,  '{' || MovementFloat.DescId :: TVarChar ||', ' || p.MovementId :: TVarChar || '}' as pk_values from MovementProtocol as p join MovementFloat on MovementFloat.MovementId = p.MovementId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 22 as num , p.id , 'MovementDate' as table_name, '{descid, movementid}' as pk_keys,  '{' || MovementDate.DescId :: TVarChar ||', ' || p.MovementId :: TVarChar || '}' as pk_values from MovementProtocol as p join MovementDate on MovementDate.MovementId = p.MovementId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 22 as num , p.id , 'MovementString' as table_name, '{descid, movementid}' as pk_keys,  '{' || MovementString.DescId :: TVarChar ||', ' || p.MovementId :: TVarChar || '}' as pk_values from MovementProtocol as p join MovementString on MovementString.MovementId = p.MovementId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 22 as num , p.id , 'MovementBoolean' as table_name, '{descid, movementid}' as pk_keys,  '{' || MovementBoolean.DescId :: TVarChar ||', ' || p.MovementId :: TVarChar || '}' as pk_values from MovementProtocol as p join MovementBoolean on MovementBoolean.MovementId = p.MovementId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 22 as num , p.id , 'MovementLinkObject' as table_name, '{descid, movementid}' as pk_keys,  '{' || MovementLinkObject.DescId :: TVarChar ||', ' || p.MovementId :: TVarChar || '}' as pk_values from MovementProtocol as p join MovementLinkObject on MovementLinkObject.MovementId = p.MovementId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 22 as num , p.id , 'MovementLinkMovement' as table_name, '{descid, movementid}' as pk_keys,  '{' || MovementLinkMovement.DescId :: TVarChar ||', ' || p.MovementId :: TVarChar || '}' as pk_values from MovementProtocol as p join MovementLinkMovement on MovementLinkMovement.MovementId = p.MovementId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 


union all
 select p.OperDate, 33 as num , p.id , 'MovementItemFloat' as table_name, '{descid, movementitemid}' as pk_keys,  '{' || MovementItemFloat.DescId :: TVarChar ||', ' || p.MovementItemId :: TVarChar || '}' as pk_values from MovementItemProtocol as p join MovementItemFloat on MovementItemFloat.MovementItemId = p.MovementItemId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 33 as num , p.id , 'MovementItemDate' as table_name, '{descid, movementitemid}' as pk_keys,  '{' || MovementItemDate.DescId :: TVarChar ||', ' || p.MovementItemId :: TVarChar || '}' as pk_values from MovementItemProtocol as p join MovementItemDate on MovementItemDate.MovementItemId = p.MovementItemId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 33 as num , p.id , 'MovementItemString' as table_name, '{descid, movementitemid}' as pk_keys,  '{' || MovementItemString.DescId :: TVarChar ||', ' || p.MovementItemId :: TVarChar || '}' as pk_values from MovementItemProtocol as p join MovementItemString on MovementItemString.MovementItemId = p.MovementItemId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 33 as num , p.id , 'MovementItemBoolean' as table_name, '{descid, movementitemid}' as pk_keys,  '{' || MovementItemBoolean.DescId :: TVarChar ||', ' || p.MovementItemId :: TVarChar || '}' as pk_values from MovementItemProtocol as p join MovementItemBoolean on MovementItemBoolean.MovementItemId = p.MovementItemId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 
union all
 select p.OperDate, 33 as num , p.id , 'MovementItemLinkObject' as table_name, '{descid, movementitemid}' as pk_keys,  '{' || MovementItemLinkObject.DescId :: TVarChar ||', ' || p.MovementItemId :: TVarChar || '}' as pk_values from MovementItemProtocol as p join MovementItemLinkObject on MovementItemLinkObject.MovementItemId = p.MovementItemId where p.OperDate between '23.05.2023 21:50' and '23.05.2023 21:59' 

order by 2, 3

)

, tmp2 as (select OperDate, num , id , table_name, pk_keys,  pk_values, 'INSERT' as operation from tmp
          union all
           select OperDate, num * 100, id  , table_name, pk_keys,  pk_values, 'UPDATE' as operation from tmp
           )
 , tmp3 as (select 'public' as schema_name, table_name, pk_keys, pk_values, operation, 1 as transaction_id, 'project' as user_name, '23.05.2023 21:00':: TDateTime as last_modified  
                    , ROW_NUMBER() OVER (ORDER BY num ASC, id ASC) AS Ord
            , num, id 
            , case when operation ilike 'INSERT' then ''

                   when table_name ilike 'ObjectFloat'
                     or table_name ilike 'ObjectDate' 
                     or table_name ilike 'ObjectString' 
                     or table_name ilike 'ObjectBoolean' 
                     or table_name ilike 'MovementFloat' 
                     or table_name ilike 'MovementDate' 
                     or table_name ilike 'MovementString' 
                     or table_name ilike 'MovementBoolean' 
                     or table_name ilike 'MovementItemFloat' 
                     or table_name ilike 'MovementItemDate' 
                     or table_name ilike 'MovementItemString' 
                     or table_name ilike 'MovementItemBoolean' 
                     or table_name ilike 'object' 
                     then '{valuedata}'

                   when table_name ilike 'ObjectLink'
                     then '{childobjectId}'

                   when table_name ilike 'movement'
                     then '{statusid}'

                   when table_name ilike 'movementItem'
                     then '{amount}'

                   when table_name ilike 'MovementItemLinkObject'
                     or table_name ilike 'MovementLinkObject'
                     then '{objectid}'

                   when table_name ilike 'MovementLinkMovement'
                     then '{movementchildid}'

                   else ''

              end as upd_cols
            from tmp2 
           )
--     22047617718
--     22047615475
-- insert into _replica.table_update_data
--     22047615475
select 22047550000 + Ord, schema_name, LOWER (table_name), LOWER (pk_keys), pk_values, LOWER (upd_cols), operation, transaction_id, user_name,  last_modified, null as parentId, null as MovementId
from tmp3 
where operation ilike 'INSERT' or upd_cols <> ''
order by Ord


-- delete from _replica.table_update_data where id between 22047550000 and 22047550000 + 25000

-- select * from _replica.table_update_data order by Id limit 100

