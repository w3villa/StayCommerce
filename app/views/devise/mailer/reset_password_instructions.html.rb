<p>Hello <%= @resource.email %>!</p>


<p>Someone has requested a link to change your password. You can do this through the link below.</p>

<p><%= link_to 'Change my password',  @resource.source == 'json' ? livio.user_password_url(@resource, reset_password_token: @token) : livio.edit_user_password_url(@resource, reset_password_token: @token) %></p>


<p>If you didn't request this, please ignore this email.</p>
<p>Your password won't change until you access the link above and create a new one.</p>