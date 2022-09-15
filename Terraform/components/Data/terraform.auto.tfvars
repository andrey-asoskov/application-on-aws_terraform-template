solution       = "application"
solution_short = "app"
product_id     = "13460"

db_enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
db_instance_class                  = "db.m5.xlarge"
db_name                            = "hs_db"
db_skip_final_snapshot             = true
db_username                        = "hs_user"
#db_snapshot                        = "arn:aws:rds:us-east-1:552667997578:snapshot:hs-backup-after-init"
sec_inventory_bucket = "S3-cubetech-isoc-logs"
sec_inventory_prefix = "cubetech/ndm-app/AWSLogs"
db_engine_version    = "12.8"
