object "o1" {
  code {
  }
  object "o2" {
    code {
    }
    object "o3" {
      code {
      }
    }
    object "o4" {
      code {
      }
      data "s1" "s2"
    }
    object "o5" {
      code {
      }
      data "s3" "s4"
      data "s5" "s6"
      data "s7" hex'00'
      data "s8" hex"00"
    }
    object "o6" {
      code {
      }
      object "o7" {
        code {
        }
      } 
      data "s9" "s10"
    }
  }
}
