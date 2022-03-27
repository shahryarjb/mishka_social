# TODO: Move this part of Protocol to core of CMS and test it as top level structure
defprotocol MishkaSocial.AuthProtocol do
  @spec login(struct()) :: any
  def login(args)

  def register(args)
end
