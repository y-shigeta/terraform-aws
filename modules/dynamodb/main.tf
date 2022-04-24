resource "aws_dynamodb_table" "example" {
  name           = "Todos"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"
#  range_key      = "GameTitle"

  attribute {
    name = "id"
    type = "S"
  }

#  attribute {
#    name = "TopScore"
#    type = "N"
#  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

/*
#  global_secondary_index {
#    name               = "GameTitleIndex"
#    hash_key           = "GameTitle"
#    range_key          = "TopScore"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }
*/

  tags = {
    Environment = "production"
  }
}