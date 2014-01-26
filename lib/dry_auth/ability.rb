
=begin
NOTES

1. Protect resources in controller 
To protect resources in a namepace outside of model's namespace, e.g. FanClub::Admin::SponsorController
  with model FanClub::Sponsor 

  load_and_authorize_resource :sponsor, parent: false, class: 'FanClub::Sponsor'

parent must be set to false for that to work
See: https://github.com/ryanb/cancan/wiki/authorizing-controller-actions

=end


#module DryAuth
  class Ability
    include CanCan::Ability

    def initialize(user)

      if user.has_role? :admin
        # Admin can do all operations on all objects
        can :manage, :all
      else
        # User can edit, update and view their own profile:
        can [:show, :edit, :update], DryAuth::User, id: user.id
      end

      # Process any methods that have been added that begin with 'process_'
      self.methods.grep(/^process_/).each {|m| self.send(m, user) }

      # Define abilities for the passed in user here. For example:
      #
      #   user ||= User.new # guest user (not logged in)
      #   if user.admin?
      #     can :manage, :all
      #   else
      #     can :read, :all
      #   end
      #
      # The first argument to `can` is the action you are giving the user 
      # permission to do.
      # If you pass :manage it will apply to every action. Other common actions
      # here are :read, :create, :update and :destroy.
      #
      # The second argument is the resource the user can perform the action on. 
      # If you pass :all it will apply to every resource. Otherwise pass a Ruby
      # class of the resource.
      #
      # The third argument is an optional hash of conditions to further filter the
      # objects.
      # For example, here the user can only update published articles.
      #
      #   can :update, Article, :published => true
      #
      # See the wiki for details:
      # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    end

  end
#end

