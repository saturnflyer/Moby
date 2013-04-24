class AstRewritter
  def initialize(ast, interpretation_context)
    @ast = Production.new(ast, interpretation_context)
  end

  def rewrite!()
    ast.each do |production|
      case production.type
        when Tokens.rolemethod_call then
          data = production.data
          production[2] = ((("self_" + data[1].to_s) + "_") + data[0].to_s).to_sym
          production[1] = nil
        when Tokens.block_with_bind then
          block = production.last
          must_b_sym = "aliased_role must be a Symbol".to_sym
          local_must_b_sym = "local must be a Symbol".to_sym
          raise(must_b_sym) unless aliased_role.instance_of?(Symbol)
          raise(local_must_b_sym) unless local.instance_of?(Symbol)
          aliased_field = ("@" + aliased_role.to_s).to_sym
          temp_symbol = ("temp____" + aliased_role.to_s).to_sym
          assignment = Sexp.new
          assignment[0] = :iasgn
          assignment[1] = aliased_field
          load_arg = Sexp.new
          load_arg[0] = :lvar
          load_arg[1] = local
          assignment[2] = load_arg
          block.insert(1, assignment)
          assignment = Sexp.new
          assignment[0] = :lasgn
          assignment[1] = temp_symbol
          load_field = Sexp.new
          load_field[0] = :ivar
          load_field[1] = aliased_field
          assignment[2] = load_field
          block.insert(1, assignment)
          assignment = Sexp.new
          assignment[0] = :iasgn
          assignment[1] = aliased_field
          load_temp = Sexp.new
          load_temp[0] = :lvar
          load_temp[1] = temp_symbol
          assignment[2] = load_temp
          block[block.length] = assignment
        else
          # do nothing
      end
    end
  end

  private
  attr_reader :ast


end