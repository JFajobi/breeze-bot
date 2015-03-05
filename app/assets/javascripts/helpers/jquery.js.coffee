$.extend
  # post JSONized data to the url specified,
  # executing the provided callback on success
  # -> a useful helper, because $.post will
  # use standard query-string format (key=val&key2=val2),
  # not JSON
  postJSON: (url, data, callback, error = ->) ->
    $.ajax
      type: "POST"
      url: url
      data: JSON.stringify(data)
      success: callback
      error: error
      dataType: "json"
      contentType: "application/json"
      processData: false