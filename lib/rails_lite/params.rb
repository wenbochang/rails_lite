require 'uri'

class Params
  def initialize(req, route_params = {})
    @params = {}
    @req_body = req.body
    parse_www_encoded_form(req.query_string)
  end

  def [](key)
    @params[key]
  end

  def to_s
    str = []
    @params.each do |k,v|
      str << ["#{k} => #{v}"]
    end
    str.join(", ")
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    nested_arr = []
    nested_arr.concat URI.decode_www_form(www_encoded_form) if www_encoded_form
    nested_arr.concat URI.decode_www_form(@req_body) if @req_body

    nested_arr.each do |arr|
      arr[0] = parse_key(arr[0])
      @params = @params.deep_merge(arr_to_hash(arr, arr[1]))
    end unless nested_arr == []
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end

  def arr_to_hash(arr, h)
    return { arr[0] => h } unless arr[0].class == Array
    return { arr[0][0] => h } if arr[0].length == 1

    new_h = { arr[0].pop => h }

    arr_to_hash(arr, new_h)
  end

end
